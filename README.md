# tap-categorize-docs

tap-categorize-docs is a project designed to categorize documents using OpenAI's API and display the analyzed data in Kibana.
For every document, it provides a summary, a category, and a reliability score from 1 to 10.

## Prerequisites

- Docker
- Docker Compose

## Setup

1. Clone this repository to your local machine:
   ```sh
   git clone https://github.com/GioXeR95/tap-categorize-docs.git
   cd tap-categorize-docs
   
2. Create an .env file in the main directory and add your OpenAI API key:

   ```sh
	echo "API_KEY=<YOUR_OPENAI_KEY>" > .env
   ```
   
3. Place any document you want to analyze (currently supported formats: .png, .jpg, .jpeg, .tiff, .bmp, .gif, .pdf, .txt) in the tap-categorize-docs\files directory:

4. For Windows Hosts:

	- in tap-categorize-docs\python\bin\documentinator.py change the last 2 lines as follow:
   ```sh
   #run_watcher(folder_to_watch, outputfile, storage_dir)
   poll_directory(folder_to_watch, outputfile, storage_dir)
   ```
	- tap-categorize-docs\run dos2unixAll.bat


## Usage

1. Run the project using Docker Compose:

   ```sh
   docker compose up
   ```

2. Open Kibana in your browser to see your analyzed data:


   ```sh
	https://127.0.0.1:5601
   ```

## Supported Document Formats
	- PNG (.png)
	- JPEG (.jpg, .jpeg)
	- TIFF (.tiff)
	- BMP (.bmp)
	- GIF (.gif)
	- PDF (.pdf)
	- Text (.txt)
## License
This project is licensed under the MIT License.
