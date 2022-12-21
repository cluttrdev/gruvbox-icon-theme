export GB_DARK0_HARD='#1d2021'
export GB_DARK0='#282828'
export GB_DARK0_SOFT='#32302f'
export GB_DARK1='#3c3836'
export GB_DARK2='#504945'
export GB_DARK3='#665c54'
export GB_DARK4='#7c6f64'

export GB_GRAY="#928374"

export GB_LIGHT0_HARD='#f9f5d7'
export GB_LIGHT0='#fbf1c7'
export GB_LIGHT0_SOFT='#f2e5bc'
export GB_LIGHT1='#ebdbb2'
export GB_LIGHT2='#d5c4a1'
export GB_LIGHT3='#bdae93'
export GB_LIGHT4='#a89984'

export GB_BRIGHT_RED='#fb4934'
export GB_BRIGHT_GREEN='#b8bb26'
export GB_BRIGHT_YELLOW='#fabd2f'
export GB_BRIGHT_BLUE='#83a598'
export GB_BRIGHT_PURPLE='#d3869b'
export GB_BRIGHT_AQUA='#8ec07c'
export GB_BRIGHT_ORANGE='#fe8019'

export GB_NEUTRAL_RED='#cc241d'
export GB_NEUTRAL_GREEN='#98971a'
export GB_NEUTRAL_YELLOW='#d79921'
export GB_NEUTRAL_BLUE='#458588'
export GB_NEUTRAL_PURPLE='#b16286'
export GB_NEUTRAL_AQUA='#689d6a'
export GB_NEUTRAL_ORANGE='#d65d0e'

export GB_FADED_RED='#9d0006'
export GB_FADED_GREEN='#79740e'
export GB_FADED_YELLOW='#b57614'
export GB_FADED_BLUE='#076678'
export GB_FADED_PURPLE='#8f3f71'
export GB_FADED_AQUA='#427b58'
export GB_FADED_ORANGE='#af3a03'

# ========

PALETTE_MODE=${PALETTE_MODE:-dark}
PALETTE_ACCENT=${PALETTE_ACCENT:-green}

case ${PALETTE_MODE} in
	dark)
		case ${PALETTE_ACCENT} in
			red)
				export COLOR_ACCENT=${GB_BRIGHT_RED}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_RED}
				;;
			green)
				export COLOR_ACCENT=${GB_BRIGHT_GREEN}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_GREEN}
				;;
			yellow)
				export COLOR_ACCENT=${GB_BRIGHT_YELLOW}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_YELLOW}
				;;
			blue)
				export COLOR_ACCENT=${GB_BRIGHT_BLUE}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_BLUE}
				;;
			purple)
				export COLOR_ACCENT=${GB_BRIGHT_PURPLE}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_PURPLE}
				;;
			aqua)
				export COLOR_ACCENT=${GB_BRIGHT_AQUA}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_AQUA}
				;;
			orange)
				export COLOR_ACCENT=${GB_BRIGHT_ORANGE}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_ORANGE}
				;;
			*)
				echo "Invalid accent color."
				;;
		esac

        export COLOR_BG0_H=${GB_DARK0_HARD}
        export COLOR_BG0=${GB_DARK0}
        export COLOR_BG0_S=${GB_DARK0_SOFT}
        export COLOR_BG1=${GB_DARK1}
        export COLOR_BG2=${GB_DARK2}
        export COLOR_BG3=${GB_DARK3}
        export COLOR_BG4=${GB_DARK4}

        export COLOR_GRAY=${GB_GRAY}

        export COLOR_FG0=${GB_LIGHT0}
        export COLOR_FG1=${GB_LIGHT1}
        export COLOR_FG2=${GB_LIGHT2}
        export COLOR_FG3=${GB_LIGHT3}
        export COLOR_FG4=${GB_LIGHT4}
		;;
	light)
		case ${PALETTE_ACCENT} in
			red)
				export COLOR_ACCENT=${GB_FADED_RED}
                export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_RED}
				;;
			green)
				export COLOR_ACCENT=${GB_FADED_GREEN}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_GREEN}
				;;
			yellow)
				export COLOR_ACCENT=${GB_FADED_YELLOW}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_YELLOW}
				;;
			blue)
				export COLOR_ACCENT=${GB_FADED_BLUE}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_BLUE}
				;;
			purple)
				export COLOR_ACCENT=${GB_FADED_PURPLE}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_PURPLE}
				;;
			aqua)
				export COLOR_ACCENT=${GB_FADED_AQUA}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_AQUA}
				;;
			orange)
				export COLOR_ACCENT=${GB_FADED_ORANGE}
				export COLOR_ACCENT_NEUTRAL=${GB_NEUTRAL_ORANGE}
				;;
			*)
				echo "Invalid accent color."
				;;
		esac

        export COLOR_BG0_H=${GB_LIGHT0_HARD}
        export COLOR_BG0=${GB_LIGHT0}
        export COLOR_BG0_S=${GB_LIGHT0_SOFT}
        export COLOR_BG1=${GB_LIGHT1}
        export COLOR_BG2=${GB_LIGHT2}
        export COLOR_BG3=${GB_LIGHT3}
        export COLOR_BG4=${GB_LIGHT4}

        export COLOR_GRAY=${GB_GRAY}

        export COLOR_FG0=${GB_DARK0}
        export COLOR_FG1=${GB_DARK1}
        export COLOR_FG2=${GB_DARK2}
        export COLOR_FG3=${GB_DARK3}
        export COLOR_FG4=${GB_DARK4}
		;;
	*)
		echo "Invalid palette mode."
		;;
esac


export COLOR_PRIMARY=${COLOR_ACCENT}
export COLOR_PRIMARY_ALT=${COLOR_ACCENT_NEUTRAL}

export COLOR_SECONDARY=${COLOR_FG2}
export COLOR_SECONDARY_ALT=${COLOR_FG4}

export COLOR_DETAIL=${COLOR_FG3}
export COLOR_DETAIL_ALT=${COLOR_BG2}

