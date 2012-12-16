all: compile_installer

REV=$(shell grep define svnrev/svnrev.c | gawk '{print $$3}')

dist: compile-installer
	@tar cfj HomebrewFilter-rev42.tar.bz HomebrewFilter/
	@tar cfj HomebrewFilter-Standalone-rev42.tar.bz2 HomebrewFilter.Standalone/

clean:
	@make -C main clean
	@make -C boot clean
	@make -C installer clean
	@make -C nand-loader clean

compile_hbf:
	@make -C main
	@cp main/hbf.dol boot/source/hbf.dol

compile_boot: compile_hbf
	@make -C boot
	@cp boot/hbf_boot.dol installer/wad/00000001.app
	@cp boot/hbf_boot.dol HomebrewFilter.Standalone/boot.dol

compile_installer: compile_boot
	@tools/WadMii.exe -input "Z:$(PWD)\installer\wad" -output "Z:$(PWD)\installer\data\install.wad" || wine tools/WadMii.exe -input "Z:$(PWD)\installer\wad" -output "Z:$(PWD)\installer\data\install.wad"
	@make -C installer
	@cp installer/installer.dol HomebrewFilter/boot.dol
