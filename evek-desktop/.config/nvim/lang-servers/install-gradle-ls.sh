#!/usr/bin/sh

INSTALL_FOLDER="$HOME/.local/share/nvim"

# Set this if necessary
export JAVA_HOME="/home/thelooter/.sdkman/candidates/java/11.0.21-tem/"
export PATH="$JAVA_HOME/bin:$PATH"

# Install Gradle language server
rm -rf "$INSTALL_FOLDER/vscode-gradle"
git clone https://github.com/microsoft/vscode-gradle.git "$INSTALL_FOLDER/vscode-gradle"
cd "$INSTALL_FOLDER/vscode-gradle" && ./gradlew installDist
