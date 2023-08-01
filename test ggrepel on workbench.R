# test ggrepel on workbench

#install.packages("palmerpenguins")
#install.packages("tidyverse")
#install.packages("ggrepel")
library(palmerpenguins)
library(tidyverse)
library(ggrepel)

penguins

p <- ggplot(data = penguins, aes(x = bill_length_mm , y = flipper_length_mm ))+
  geom_point()+
  geom_text_repel(aes(label = species ))

p

# Error on workbench
> p
[31962:31962:20230801,022258.972443:ERROR process_memory_range.cc:86] read out of range
[31962:31962:20230801,022258.972478:ERROR elf_image_reader.cc:558] missing nul-terminator
[31962:31962:20230801,022258.972561:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.974446:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.974475:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.974507:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.974536:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.974567:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.974924:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.974953:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975137:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975165:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975193:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975220:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975266:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975296:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975323:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975350:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975378:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975404:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975432:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975461:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975490:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975530:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975559:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975589:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975619:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975648:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975675:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975706:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975734:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.975768:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.976724:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.976753:ERROR elf_dynamic_array_reader.h:61] tag not found
[31962:31962:20230801,022258.976971:ERROR file_io_posix.cc:140] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq: No such file or directory (2)
[31962:31962:20230801,022258.976983:ERROR file_io_posix.cc:140] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq: No such file or directory (2)
[31962:31964:20230801,022258.978596:ERROR directory_reader_posix.cc:42] opendir: No such file or directory (2)