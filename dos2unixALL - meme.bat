@echo off
echo "Start"

for /R "%cd%" %%f in (*) do (
	echo "%%f"|find "\.git\" || echo "%%f"|find ".bat" >nul
	if errorlevel 1 (dos2unix.exe "%%f") else (
echo "#####%%@@@%%%%@%%%%%%%%%%%%%%%%#*#*#%%@@%%%%%%%%%%%%%%%%##%%#***###*********++++++*#%%%%##**#***#####*****=++++======++==+++++==++++===---:......    .--==+++****############"
echo "*####%%@@@#%%%%%%#####%%#**#**%%@%%##########%%#***#**********+++++++*%%@#*#++*++*#**##*****=+*+*+====+++==+++*+=========--:.          .:-==++*****************"
echo "####%%@@@@#%%%%######%%%%*##*#@@@%%######%%##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@#*#+=**+*#**##*+*#*=+++**++==+++===++++=====-==---.           .:-=+++++++============="
echo "%%%%%%%%%%@@@%%%%@%%%%%%%%%%%%%%%%#*##*#@@%%#####%%%%%%##%%########################%%**#++#%%%%%%###%%%%#****=++***++===+===+++++====---===-.           :--===-------------====="
echo "#####@@@%%%%%%#######%%#*##*%%@@%%#######%%#%%%%***********************#%%###++#********####*++****++==+++==+*+++===========.          .:--------------===++++++"
echo "****#@@@%%%%@@%%%%%%%%%%%%%%#*##*%%@@@%%%%%%%%%%%%%%%%#%%#**********************##%%******#######*****+=*****++==+++==++++++++++======-.       .::----------===+++******++"
echo "****%%@@@%%%%@%%######%%#*#**%%@@%%####*####%%#*******##**##**#*****##%%%%**##%%%%%%@@%%%%%%%%%%%%#***+*****+===+++==++====++++===+====-::::::-----=======++++******+++++"
echo "****%%@@@%%@@%%####%%%%%%###**%%@@@%%%%%%%%%%%%%%%%#%%#*****############*****####%%@@@@@@@@@@@%%%%@@##**+***++==++++======+++++++++===----------=====++++****************"
echo "****%%@@@%%@@%%%%####%%%%###*#@@@%%%%%%####%%%%%%@####**########*********##%%@@@@@@@@@@@@@@@@@%%%%####***+=++*++******+******+==--------====++++++*******************"
echo "***#%%@@@%%@@%%#####%%%%###*#@@@%%%%#####%%%%%%@#*########**************%%@@@@@@@@#***##%%@@@@@@%%%%#**++=++*++*###*++**++==---------==++++++***********************"
echo "***#@@@@%%@@@%%%%%%%%@@%%###*#@@@@%%%%%%%%%%%%%%#%%@#**********************%%@@@@@@@%%#*********#@@%%%%@%%##*+=+**++*######*++===----====+++*****************************"
echo "*###@@@@%%@%%%%#####%%%%#%%%%#%%@@@#######%%%%%%@%%#%%%%####%%##############%%@@@@@#***************+=-*###+=+**++*#%%%%##*++++++++===++************##*******************"
echo "%%%%%%%%@@@@%%@@@@@%%@@@%%#%%%%#%%@@@@%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%###%%%%%%%%%%##%%%%%%###++%%@@%%*++***************+=-*#*==**#**#%%%%%%#*++++++***************########******************"
echo "####@@@@@@%%%%%%%%#%%%%%%%%#%%%%#%%@@@%%######%%%%@@##########################%%*+****#%%%%%%%%##****+++==*%%#+=**#*+*####+====++*###%%##*******###################********"
echo "***%%@@@@@@@%%%%%%%%%%@@%%%%%%##@@@@%%%%%%%%%%%%%%%%%%@%%#*********************#%%#**++**##%%%%@@@@%%%%##***+=+#%%%%*++**+**##*+=====+**#%%%%%%%%###########################**######"
echo "***%%@@@@@@@%%%%%%%%%%@%%%%%%%%##@@@%%%%%%###%%%%%%%%@%%#***###***************+*#***+****##%%#%%%%%%%%##%%@%%%%**%%@@%%**#######*====++*#%%@@@%%%%%%###%%##########%%%%%%%%##########%%%%%%%%##"
echo "**#@@@@@@@%%%%%%%%%%%%@@%%%%%%#%%@@@@##%%###%%%%%%@%%#***########**********#********##*######**%%%%%%%%%%#%%%%@@%%##%%%%####*+===+*#%%@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%####"
echo "**#@@@@@@@@@@@@@@@%%%%%%#%%@@@@@@%%%%%%%%@%%%%@%%#***########**********#+=******##**####*++*##*+%%@@%%%%%%##%%%%%%%%%%#+==+*#%%%%%%%%%%%%%%#####%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##%%##"
echo "-*#@@@@@@@%%%%%%%%%%%%@@%%%%%%%%%%@@@%%%%%%####%%%%%%@%%#**##%%%%####******###*##=+#****#########*+=+*#++%%@@@@@%%%%%%%%###*+=+*#%%%%###########%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%"
echo "..+@@@@@@@@@@@@@@@%%%%%%%%%%@@@@@@@@@@@%%%%@%%#*###%%###**#*****#####*+*#########**#%%%%%%%%%%****#%%%%@@@@%%%%%%#**#+++##%%##########%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "...*@@@@@@%%%%%%%%%%%%@%%%%%%%%#@@@@%%%%%%%%%%%%%%%%%%%%@%%######################+*#%%%%%%###%%%%%%%%#####*+**+*##%%@@@%%###****+*############%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%"
echo ":::=@@@@@@%%%%%%%%%%@@%%%%%%%%#@@@@%%%%%%%%%%%%%%@%%@@@%%%%%%%%%%@@@@@@@@@@@@@@@@%%*##%%@@%%%%%%@@%%%%%%#%%%%%%#*+*+**%%@@@@#****+**+*#########%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%"
echo "-:-=@@@@@@%%%%%%%%@@@%%%%%%%%%%@@@@@@%%%%%%%%%%%%%%@@%%########%%%%%%%%%%%%%%%%%%#**%%@@@@@@@@@@@%%%%%%%%#***%%%%#**##%%@@%%%%***#*++**#########%%%%@@@@@@@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "+=-+@@@@@@%%%%%%%%%%@@%%%%%%%%%%@@@@%%%%###%%%%@@@@###################@@@@@@@@@@@@@@@%%%%%%%%%%%%%%@@%%**##%%%%%%%%%%#*##*++**##*#####%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "#+-*@@@@@@@@@@@@@%%%%@%%#@@@@@@%%%%%%@@@@@%%#***###*****##**+#@@@@@@@@@@@@@@@@@@@@%%@@@@++*##%%%%%%%%%%%%#**+++*#***###%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%"
echo "---*@@@@@%%%%%%%%%%%%@@%%%%%%##@@@@%%%%%%#%%%%%%@@@%%****#######****#%%%%%%@@@@@@@@@@@@@@@@@@@@@@%%++++*#%%@@%%%%%%#**++*****###%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%"
echo "==+*@@@@@@@@@@@@@%%%%%%#%%@@@@%%%%%%%%%%%%@@%%@%%***###****+*%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@%%%%*++*#%%%%@%%%%%%###*+****###%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%@"
echo "#*+*@@@@@@@@@@@@@%%%%%%*#@@@@%%%%%%%%%%%%@@@@%%**+=====**###@%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@%%%%#*+++#@@%%%%##*++****##%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "%%#+#@@@@@%%%%%%%%%%%%@@%%%%%%*#@@@%%%%#####%%*+++****++=+*####%%@@@@@@@@@@@@@@@@@@@@@@@@@@%%@%%%%#*****++##***++***##%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "%%#@@@@@@@@@@@@@@@%%@%%#%%@@@@@@@@@@%%%%%%%%####%%#**+*#*#%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%##**+*#**++==++**#%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "%%%%@@@@@@@@@@%%%%%%@@%%@%%#@@@@%%%%%%%%%%###@@%%%%%%%%%%%%%%##*+#*%%@@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%######*#**+++**#%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "-:%%@@@@@@@@@@@@@@%%@%%#@@@@@@@@##%%@@@@@@@@%%%%%%@%%**#*%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%##%%%%#**#**+++*#%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo ":::@@@@@@@@@@@@@@%%@#%%@@@@@%%%%%%%%@@@@@@@@@@@@@@@%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%#%%%%#*#***+*#%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "-:.+@@@@@@@@@@@@%%%%%%+%%@@@@%%%%##%%@@@@@@@@@@@@@@@%%#%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%#%%%%@@%%#**#%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "=-:-@@@@@@@@@@@@%%%%#=#@@@@@%%%%%%@@@@@@@@@@@@@@@@@@%%@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%#***#%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "*=...:%%@@@%%%%%%@@@%%%%*=#@@@%%##%%@@@@@@@@@@@@@@@@@%%@@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%@%%@##%%@%%***##%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "-:=-...:=-. .#@@%%%%*+%%@@@@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%@@@%%%%%%@@%%#**##%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "*+===--===-.   .:-=+%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%@@%%%%%%%%%%#**##%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "*****++==+*-..:===*+%%@@@%%%%@@@@@@@@@@@@@@@@@@@@@@@%%@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%#**#%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "####**++++===+:.::..=@@%%##%%@@@@@@@@@@@@@@@@@@@@@@%%@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%@%%#**#%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "###***#**#%%%%%%%%+-=-:..:=###%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%#@#@@@#*#%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "%%#%%@%%####%%%%%%##*+=--:::=***%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%+++++@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "%%#*#%%%%%%%%%%%%%%%%%%#**%%##*=#@%%##%%@@@@@@@@@@@@@@@@@@@@@@@@*+=#@@@***#**@@@@@@@@@@@@@@@@@@@%%@@@@@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "%%#**#%%%%%%@%%%%#**#*#*+=:.=%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@#***%%@##**#**@@@@@@@@@@@@@@@@%%@@@@@@@@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@%%##%%@%%@@@#*##*##%%++:.=#@@@@@@@@@@@@@@@@@@@@@@@@@@@%%#**#%%##*##**@@@@@@@@@@@@@@@@@@@@@@@%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@%%#*#@@@@@%%%%%%%%###%%++:.-*#%%%%@@@@@@@@@@@@@@@@@@@@@@@@%%***+#%%#*##*+@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%"
echo "%%#**#@@@@@@%%%%%%%%#%%%%#*-.-##%%%%@@@@@@@@@@@@@@@@@@@@@*+*#*#**%%%%#***+==@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%"
echo "@#**#@@@@@@@%%%%%%%%%%%%%%+-.-#%%%%@@@@@@@@@@@@@@@@@@@@@@#**#%%%%*+***+++*++%%@@@@@@@@@@@@@@@@@@@@%%%%##%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%"
echo "@%%#**%%@@@@@@@@%%@@@@+-.-#@@@@@@@@@@@@@@@@@@@@@@@@@****#*++++*****+*@@@@@#+====%%@@@@@@@@%%%%##%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@%%%%%%#%%@@@@@@%%@%%@@@@*-:-#@@@@@@@@@@%%%%%%%%%%%%%%@@@@@@@@@*+++++++*******++++++++++++#@@@%%@%%@@%%###%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@@@%%#@@@@@%%%%%%%%@@@@#=:-#@@@@@@@@@%%@@@%%@@@@@@%%%%%%%%@@%%*+++++++********#####***%%%%@@@@@@@@@%%##%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@%%%%%%@@@@@@@@@@@@@@#+::+#%%@@@@@@@@@@@@@@@@@@@@@@@%%#**++++++*##*****##%%@@@@@@@@@@@@@@@@%%###%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "*+=-=#@@@@@@@%%@@@@@@*-:+##@@@@@@@@@@@@@@@@@@@@@@@@@%%***+++*****#*#%%@@@@@@@@@@@@@@@@@@@%%###%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "==---+@@@@@%%%%%%%%@@@@@@@*-=*#@@@=**+=@:-%%@.@@@@@@@@@@@.%%#**%%@@@@@@ **@@@@@@:#%%@%%@@%%@@.@.#**#%%#%%@@.%%@@#=@@@@@@@@@@@@@@@@***@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "=----+@@@@@%%%%%%@@%%%%%%%%@@-::--@@@@@@@:#=%%*=**=%%++@@@.@@.%%=@@-@:@@-@@*#@@@.#@.#-@@:%%@@@.@ ## #**+=@.@@@#:@*+%%:#*=#.@=+%%-#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "==----#%%%%@@%%%%%%%%###%%%%%%%%:....=@@@@@@* @@- @**@##@@@.@@.%%=@%%-@-@@-@@*#@@@ #@ #-%%@-#@@@:@.@%% *=%%#=@:@@@#=@#=%%-@@+#-@=#@+%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "===---+%%@@@%%%%##%%%%%%%%%%%%%%:..:::*@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%@@@@@@@@@@@@@@@@@@@%%#@@@@@%%@@@%%%%@%%#@@@@@@@@@@@@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "+===--=%%%%@@%%%%@%%%%%%%%%%%%%%*:::::--+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%@@@@@@@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "++===-=#%%#@%%%%@@@@%%%%%%#+-:----====+#%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%@@@@@@@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	)
)
pause