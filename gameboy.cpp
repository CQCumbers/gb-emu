#include "gameboy.h"

// Core Functions

Gameboy::Gameboy(const std::string &filename, const std::string &save)
    : mem(filename, save), cpu(mem), ppu(mem), apu(mem), timer(mem),
      joypad(mem) {}

void Gameboy::step() {
  joypad.update();
  unsigned cycles = cpu.execute();
  timer.update(cycles);
  ppu.update(cycles);
  apu.update(cycles);
}

void Gameboy::update() {
  while (ppu.get_mode() == 1)
    step();
  while (ppu.get_mode() != 1)
    step();
}

void Gameboy::input(Input input_enum, bool val) {
  joypad.input(input_enum, val);
}
