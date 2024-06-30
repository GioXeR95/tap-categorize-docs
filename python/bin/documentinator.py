import os
import pytesseract
from PIL import Image
import base64
import json
import time
import shutil
import asyncio
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import aiofiles
import fitz  # PyMuPDF
import uuid
import datetime


def get_file_creation_time(file_path):
    return time.ctime(os.path.getctime(file_path))
def get_file_size(file_path):
    return os.path.getsize(file_path)
def get_file_extension(file_path):
    return os.path.splitext(file_path)[1]
def get_last_edit_timestamp(file_path):
    # Get the last modification time of the file
    if os.path.exists(file_path):
        return time.ctime(os.path.getmtime(file_path))
    else:
        return None  # Handle the case where the file does not exist
def get_base64_encoding(file_path):
    with open(file_path, "rb") as file:
        encoded_string = base64.b64encode(file.read()).decode("utf-8")
    return encoded_string

def extract_text_from_image(file_path):
    text = pytesseract.image_to_string(Image.open(file_path))
    return text

def read_pdf(file_path):
    pdf_document = fitz.open(file_path)
    text = ""
    for page_num in range(len(pdf_document)):
        page = pdf_document.load_page(page_num)
        text += page.get_text()
    pdf_document.close()
    return text

def ocr_pdf(file_path):
    pdf_document = fitz.open(file_path)
    text = ""
    for page_num in range(len(pdf_document)):
        page = pdf_document.load_page(page_num)
        image_list = page.get_pixmap()
        img = Image.frombytes("RGB", [image_list.width, image_list.height], image_list.samples)
        page_text = pytesseract.image_to_string(img)
        text += page_text
    pdf_document.close()
    return text

def extract_text_from_pdf(file_path):
    try:
        if os.path.getsize(file_path) == 0:
            raise Exception("File is empty")
        text = read_pdf(file_path)
        if not text:
            text = ocr_pdf(file_path)
    except Exception as e:
        print(f"Error extracting text from PDF: {e}")
        text = ocr_pdf(file_path)
    return text

def extract_text_from_txt(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        return content

def extract_text_from_file(file_path):
    if file_path.lower().endswith(('.png', '.jpg', '.jpeg', '.tiff', '.bmp', '.gif')):
        return extract_text_from_image(file_path)
    elif file_path.lower().endswith('.pdf'):
        return extract_text_from_pdf(file_path)
    elif file_path.lower().endswith('.txt'):
        return extract_text_from_txt(file_path)
    else:
        return "content-not-classified"
    
def generate_uuid_for_file(filename):
    # Get current timestamp
    current_time = datetime.datetime.now().strftime("%Y%m%d%H%M%S%f")

    # Combine filename and timestamp
    combined_str = f"{filename}-{current_time}"

    # Generate UUID from the combined string
    file_uuid = uuid.uuid5(uuid.NAMESPACE_OID, combined_str)

    # Convert UUID to string for easy storage or display
    file_uuid_str = str(file_uuid)

    return file_uuid_str

async def process_file(file_path, outputfile, storage_dir):
    file_name = os.path.basename(file_path)
    print(f"Processing file: {file_name}")


    file_data = {
        "uuid": generate_uuid_for_file(file_name),
        "file_name": file_name,
        "file_size": get_file_size(file_path),
        "file_extension": get_file_extension(file_path),
        "content": extract_text_from_file(file_path),
        "last_edit": get_last_edit_timestamp(file_path),
        "data_creation": get_file_creation_time(file_path)
    }

    async with aiofiles.open(outputfile, "a") as json_file:
        await json_file.write(json.dumps(file_data) + "\n")

    shutil.move(file_path, os.path.join(storage_dir, file_name))
    print(f"Moved file to storage: {file_name}")

def poll_directory(directory_path, outputfile, storage_dir):
    while True:
        for filename in os.listdir(directory_path):
            file_path = os.path.join(directory_path, filename)
            if os.path.isfile(file_path):
                asyncio.run(process_file(file_path, outputfile, storage_dir))
        time.sleep(10)

class Watcher(FileSystemEventHandler):
    def __init__(self, outputfile, storage_dir):
        self.outputfile = outputfile
        self.storage_dir = storage_dir

    def on_created(self, event):
        if not event.is_directory:
            # Delay processing to ensure file is fully written
            time.sleep(1)
            asyncio.run(process_file(event.src_path, self.outputfile, self.storage_dir))


def run_watcher(directory_to_watch, outputfile, storage_dir):
    print("Watcher is running")
    print(f"Directory to watch: {directory_to_watch}")
    print_filenames(directory_to_watch)
    print(f"Output file: {outputfile}")
    print(f"Storage directory: {storage_dir}")

    event_handler = Watcher(outputfile, storage_dir)
    observer = Observer()
    observer.schedule(event_handler, directory_to_watch, recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

def print_filenames(folder_path):
    try:
        filenames = os.listdir(folder_path)
        print(f"Files in folder '{folder_path}':")
        for filename in filenames:
            print(filename)
    except FileNotFoundError:
        print(f"The folder '{folder_path}' does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    outputdir = os.getenv("outputdir", "/documentinator-out/")
    outputfile = os.path.join(outputdir, "documents.jsonl")
    print("Outfile " + outputfile)

    os.makedirs(outputdir, exist_ok=True)

    folder_to_watch = "/usr/src/app/files"
    storage_dir = os.path.join(folder_to_watch, "storage")
    with open(outputfile, "w") as json_file:
        json_file.write("")
    os.makedirs(storage_dir, exist_ok=True)

    run_watcher(folder_to_watch, outputfile, storage_dir)
    #poll_directory(folder_to_watch, outputfile, storage_dir)
