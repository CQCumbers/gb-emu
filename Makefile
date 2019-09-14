# Compile the main executable
main.exe: memory.cpp cpu.cpp ppu.cpp apu.cpp timer.cpp joypad.cpp gameboy.cpp main.cpp blip_buf.c
	g++ -std=c++11 -Wall -Wextra -O3 -fno-rtti -fno-exceptions \
	memory.cpp cpu.cpp ppu.cpp apu.cpp timer.cpp joypad.cpp gameboy.cpp main.cpp blip_buf.c -o main.exe \
	-I/Library/Frameworks/SDL2.framework/Headers -F/Library/Frameworks -framework SDL2

# Compile main executable to wasm
index.html: memory.cpp cpu.cpp ppu.cpp apu.cpp timer.cpp joypad.cpp gameboy.cpp main.cpp blip_buf.c
	emcc -Wall -Wextra -O3 -fno-rtti -fno-exceptions \
	memory.cpp cpu.cpp ppu.cpp apu.cpp timer.cpp joypad.cpp gameboy.cpp main.cpp blip_buf.c \
	-o docs/index.html --llvm-lto 1 --emrun --shell-file base.html -s USE_SDL=2 \
	-s EXPORTED_FUNCTIONS='["_load", "_save", "_main"]' -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall"]' \
	-s FORCE_FILESYSTEM=1 -s ALLOW_MEMORY_GROWTH=1 -s ENVIRONMENT='web'

# serve wasm executable
serve: index.html
	workbox generateSW workbox-config.js && \
	emrun --no_browser --port 8080 docs/index.html

# Remove automatically generated files
clean:
	rm -rvf *.exe *~ *.out *.dSYM *.stackdump dist/*

# Run cppcheck static analyzer
check:
	cppcheck --enable=all --inconclusive --std=c++11 .

# Run clang-format
format:
	clang-format -i *.cpp *.h
