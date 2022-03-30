git clone https://github.com/JochenBe/Swiftly ~/.swiftly/install

pwd=$(pwd)

cd ~/.swiftly/install

swift build -c release

echo

$(swift build -c release --show-bin-path)/swiftly install JochenBe/Swiftly

cd $pwd

rm -rf ~/.swiftly/install

echo export PATH=\$PATH:\~/.swiftly/bin >> ~/.profile

export PATH=$PATH:\~/.swiftly/bin
