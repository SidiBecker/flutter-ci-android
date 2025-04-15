FROM ghcr.io/cirruslabs/flutter:3.29.2

# Definindo variável de ambiente do Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk

# Atualiza e instala dependências básicas
RUN apt-get update && \
    apt-get install -y wget unzip zip libc6-i386 lib32stdc++6 lib32gcc-s1 lib32ncurses6 lib32z1 && \
    rm -rf /var/lib/apt/lists/*

# Cria diretórios necessários
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

# Baixa e instala o Android Command Line Tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O android-tools.zip && \
    unzip android-tools.zip -d cmdline-tools-temp && \
    mv cmdline-tools-temp/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm -rf android-tools.zip cmdline-tools-temp

# Atualiza o PATH
ENV PATH=$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$PATH

# Aceita as licenças e instala pacotes necessários
RUN yes | sdkmanager --licenses || true && \
sdkmanager --list | grep cmake && \
sdkmanager \
  "platform-tools" \
  "build-tools;34.0.0" \
  "build-tools;35.0.0" \
  "platforms;android-34" \
  "platforms;android-35" \
  "ndk;27.2.12479018" \
  "cmake;3.22.1"

# Confirma que tudo instalado
RUN sdkmanager --list

# Verifica se os executáveis estão nos caminhos certos
RUN which sdkmanager && \
    which adb && \
    which java


# Instala dependências do Ruby e fastlane
RUN apt-get update && \
apt-get install -y ruby-full && \
gem install fastlane && \
fastlane --version

RUN which fastlane
