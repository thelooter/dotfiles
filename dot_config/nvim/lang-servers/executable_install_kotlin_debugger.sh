#!/usr/bin/sh

INSTALL_FOLDER="$HOME/.local/share/nvim"

# Set this if necessary
export JAVA_HOME="$HOME/.sdkman/candidates/java/17.0.9-tem/"
export PATH="$JAVA_HOME/bin:$PATH"


# Install kotlin-debug-adapter
rm -rf "$INSTALL_FOLDER/kotlin-debug-adapter"
git clone https://github.com/fwcd/kotlin-debug-adapter.git "$INSTALL_FOLDER/kotlin-debug-adapter"
cd "$INSTALL_FOLDER/kotlin-debug-adapter" && ./gradlew :adapter:installDist
