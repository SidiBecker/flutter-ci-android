FROM ghcr.io/cirruslabs/flutter:3.29.2

ENV ANDROID_SDK_ROOT=/opt/android-sdk

RUN apt-get update && \
    apt-get install -y wget unzip zip libc6-i386 lib32stdc++6 lib32gcc-s1 lib32ncurses6 lib32z1 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O android-tools.zip && \
    unzip android-tools.zip -d cmdline-tools-temp && \
    mv cmdline-tools-temp/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm -rf android-tools.zip cmdline-tools-temp

ENV PATH=$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$PATH

RUN yes | sdkmanager --licenses || true && \
sdkmanager --list | grep cmake && \
sdkmanager \
  "platform-tools" \
  "build-tools;34.0.0" \
  "platforms;android-34" \
  "ndk;27.2.12479018" \
  "cmake;3.22.1"

RUN sdkmanager --list

RUN which sdkmanager && \
    which adb && \
    which java

RUN apt-get update && \
apt-get install -y ruby-full && \
gem install fastlane && \
fastlane --version

RUN which fastlane
