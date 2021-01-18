g:='/smb/c/Users/cgf/Documents/Elder Scrolls Online/live/AddOns'
e:='/home/cgf/.local/share/Steam/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns'
n:=$(notdir ${CURDIR})
txt:=$($n.txt)
ALL:=$(shell { echo $n.txt; egrep -v '^[        ]*(;|\#|$$)' $n.txt; ls textures/* 2>/dev/null;} | sed -e 's/\.lua$$/\.lua.ok/' | sort)
.PHONY: all
all:  ${ALL}

.PHONY: install
install: all
	rsync -aR ${ALL:.ok=} ${txt}  $g/$n/
	rsync -aR ${ALL:.ok=} ${txt}  $e/$n/
	@touch $e/POC/POC.txt $g/POC/POC.txt

PvpAlerts_Init_Globals.lua.ok: PvpAlerts_Init_Globals.lua
	@unexpand -a -I $?
	esolua $?
	@touch $@

%.lua.ok: %.lua
	@unexpand -a -I $?
	esolua $?
	@touch $@
