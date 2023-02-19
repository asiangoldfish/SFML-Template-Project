# SFML-Template-Project

Create a new SFML project template for Visual Studio, MSVC++ v142

# Instructions
## Windows and MacOS
- Currently, the script is only available as a Bash script. An environment with Bash installed is therefore required. While MacOS has Bash preinstalled, Windows does not. On Windows, the project been tested in the following environments:
  - Debian on Windows Subsystem for Linux
  
- Download the project and setup the script using the following commands:
  ```
  git clone https://github.com/asiangoldfish/SFML-Template-Project.git
  cd SFML-Template-Project
  chmod u+x sfml_newProject.sh
  ```
- Add an alias to executing the script:
  ```
  printf 'alias sfml_newProject=\"bash %s/sfml_newProject.sh\"\n' "$PWD" >> ~/.bash_aliases
  ```
- Restart the shell. The script is now ready to be executed. To create a new project, navigate to the directory where it'll be created and execute the following command:
  ```
  sfml_newProject
  ```
  You will be prompted with entering the project name, or let it choose the default name. This name will not affect the new project in any way.
- Go to the new project directory and open the solution file (.sln) in Visual Studio. All libraries and headerfiles have been set to work in 32-bit debug mode, so make sure you are working in this mode.
- Compile and execute the program to make sure that everything is working. You should see a small, new window with a green circle.

## Linux
The script only generates a Visual Studio project. This project is therefore not for Linux environments.

# How it works
The archive file _sfml_template.tar.gz_ contains a Visual Studio solution, and a copy of SFML binaries and include files. To open the new project in Visual Studio, simply open the File Explorer and double click on the solution file.
