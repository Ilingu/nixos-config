{ config, pkgs, ... }:

let
  my-python-packages = ps: with ps; [
	matplotlib
	numpy
  ];
in

let
  unstable = import <nixos-unstable> {};
in {
  # Define a user account.
  users.users.ilingu = {
    isNormalUser = true;
    description = "Ilingu";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "libvirtd" "scanner" "lp" ]; # enable sudo, network, medias, docker, VM, scanning
    shell = pkgs.fish; # set default shell to fish

    packages = with pkgs; [
	unstable.brave
	gnome.gnome-tweaks
	#gnome.iagno
	pika-backup
	gnome.gnome-power-manager
	bleachbit
	#via
	veracrypt
	#insomnia
	vscodium
	libreoffice
	audacity
	gimp
	#signal-desktop
	geogebra
	pdfarranger
	firmware-manager
	# discord clients
	unstable.webcord
	# AI
	unstable.upscayl
	#unstable.ollama
	# unstable.freetube # doesn't work, see: https://github.com/FreeTubeApp/FreeTube/issues/3953
	newsflash
	wl-color-picker
	vlc
	# spotify
	# spot -> doesn't work anymore
	mullvad-vpn
	qbittorrent
	# gnome-latex -> useless
	texlive.combined.scheme-full
	tor-browser-bundle-bin
	ffmpeg
	# Prog
	nodejs_18
	bun
	(python3.withPackages my-python-packages)
	
	ocaml
	opam
	ocamlPackages.lsp
	ocamlPackages.ocamlformat
	ocamlPackages.utop
	
	gnumake
	
	go
	gopls
	delve
	go-tools
	
	rustup
	gcc
	# VMs
	virt-manager
	gnome.gnome-boxes
	#gtk
	graphite-gtk-theme # theme
	tela-icon-theme # icon theme
	# fish plugins
	fishPlugins.autopair
	fishPlugins.puffer
	fishPlugins.sponge
	fishPlugins.z
	fishPlugins.fzf
	# gnome extensions
	gnomeExtensions.pano
	gnomeExtensions.caffeine
	
	gnomeExtensions.desktop-icons-ng-ding # see: https://gitlab.com/rastersoft/desktop-icons-ng/-/issues/284
	gjs # this is required for "desktop-icons-ng-ding" to work. see: https://gitlab.com/rastersoft/desktop-icons-ng/-/issues/284#note_1533950514
	
	#gnomeExtensions.emoji-selector, not compatible
	gnomeExtensions.openweather
	gnomeExtensions.search-light
	gnomeExtensions.top-bar-organizer
	gnomeExtensions.hide-activities-button
	gnomeExtensions.vitals
	gnomeExtensions.appindicator
	#gnomeExtensions.color-picker, don't work
    ];
  };
  
 # Init Home Manager
 home-manager.useUserPackages = true;
 home-manager.useGlobalPkgs = true;
 home-manager.users.ilingu = { pkgs, ... }: {
 	# Shell
	programs.fish = {
		enable = true;
	    	interactiveShellInit = ''
      			set fish_greeting # Disable greeting
    		'';
		shellInit = ''
			starship init fish | source
			set -x PATH $PATH:$HOME/Prog/CustomScripts
			set -x PATH $PATH:$HOME/.npm-global/bin
			source /home/ilingu/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
		'';
		shellAbbrs = {
			hatsh = "cd /home/ilingu/Downloads/Software/hat.sh && npm run start";
			editor = "gnome-text-editor";
			nixconf = "sudo gnome-text-editor /etc/nixos/configuration.nix";
			nixbuild = "sudo nixos-rebuild switch";
			findall = "/home/ilingu/Prog/BashScript/findall.sh";
			icat = "kitty +kitten icat --align=left";
			trash = "/home/ilingu/Prog/BashScript/trash.sh";
			explorer="nautilus";
			cls = "clear";
			gcp = "gcp.sh";
			#rm = "trash";
		};
		plugins = [
			{ name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
			{ name = "puffer-fish"; src = pkgs.fishPlugins.puffer.src; }
			{ name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
			{ name = "z"; src = pkgs.fishPlugins.z.src; }
			{ name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
		];
	};
 	programs.starship = {
 		enable = true;
 		settings = {};
 	};
 	
 	# Terminal
 	programs.kitty = {
 		enable = true;
 		shellIntegration.enableFishIntegration = true;
 		font = { 
 			name = "JetBrains Mono Regular";
 			size = 12.0;
 		};
 		theme = "Rosé Pine";
		settings = {
			# Fonts
			italic_font = "JetBrains Mono Italic";
			bold_font = "JetBrains Mono ExtraBold";
			bold_italic_font = "JetBrains Mono ExtraBold Italic";
			
			# Controls
			allow_remote_control = true;
			
			# Layouts
			enabled_layouts = "tall:bias=50;full_size=1;mirrored=false";
			
			# Bg
			background_opacity = "0.95";
		};	
 	};
 	
	# gtk theme
	gtk = {
		enable = true;
		font = {
			name = "JetBrains Mono Regular";
			size = 10;
			package = pkgs.jetbrains-mono;
		};
		theme = {
			name = "Graphite-Dark";
			package = pkgs.graphite-gtk-theme;
		};
		iconTheme = {
			name = "Tela-black";
			package = pkgs.tela-icon-theme;
		};
	};
 	
	# Prog
	programs.git = {
		enable = true;
		userName = "ilingu";
		userEmail = "ilingu@duck.com";
		extraConfig = {
			init.defaultBranch = "main";
			user.signingkey = "E74C820E1FDAF6EA";
			commit.gpgsign = true;
			#credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
		};
      	};
	
	
	# enable vscodium + config
	programs.vscode = {
		enable = true;
		package = pkgs.vscodium;
		#mutableExtensionsDir = false;
		userSettings = {
			  # Design
			  "editor.bracketPairColorization.enabled" = true;
			  "editor.guides.bracketPairs" = "active";
			  "breadcrumbs.enabled" = true;
			  "debug.toolBarLocation" = "floating";
			  "editor.autoIndent" = "full";
			  "editor.cursorStyle" = "line";
			  # Font/Style
			  "editor.fontSize" = 17;
			  "editor.fontWeight" = "500";
			  "editor.letterSpacing" = 0;
			  "editor.lineHeight" = 23;
			  "editor.fontFamily" = "'JetBrains Mono'; Consolas";
			  "editor.fontLigatures" = true;
		 	  "workbench.colorTheme" = "Rosé Pine";
		 	  "cSpell.language" = "en,fr";
			  # Windows
			  "files.autoSave" = "afterDelay";
			  "files.autoSaveDelay" = 5000;
			  "search.showLineNumbers" = true;
			  "workbench.iconTheme" = "material-icon-theme";
			  "zenMode.centerLayout" = false;
			  # "window.title" = "${dirty}👨‍💻 ${rootName}${separator}${activeEditorShort}";
			  "editor.tabSize" = 2;
			  "explorer.confirmDelete" = false;
			  "workbench.statusBar.visible" = true;
			  "workbench.sideBar.location" = "left";
			  "workbench.editor.wrapTabs" = true;
			  "editor.wordWrap" = "on";
			  "extensions.ignoreRecommendations" = true;
			  "editor.wordWrapColumn" = 120;
			  "editor.suggestSelection" = "first";
			  "files.exclude" = {
			    "**/.classpath" = true;
			    "**/.project" = true;
			    "**/.settings" = true;
			    "**/.factorypath" = true;
			  };
			  "editor.minimap.maxColumn" = 200;
			  "editor.minimap.scale" = 3;
			  "editor.minimap.renderCharacters" = false;
			  "editor.minimap.enabled" = false;
			  "typescript.updateImportsOnFileMove.enabled" = "always";
			  "javascript.updateImportsOnFileMove.enabled" = "always";
			  # Formatter
			  "editor.defaultFormatter" = "esbenp.prettier-vscode";
			  "editor.formatOnSave" = true;
			  "editor.formatOnPaste" = true;
			  "[javascript]" = {
			    "editor.defaultFormatter" = "esbenp.prettier-vscode";
			  };
			  "[typescript]" = {
			    "editor.defaultFormatter" = "esbenp.prettier-vscode";
			  };
			  "[svelte]" = {
			    "editor.defaultFormatter" = "svelte.svelte-vscode";
			  };
			  "[html]" = {
			    "editor.defaultFormatter" = "esbenp.prettier-vscode";
			  };
			  "[python]" = {
			    "editor.defaultFormatter" = null;
			    "editor.formatOnPaste" = false;
			  };
			  "[prisma]" = {
			    "editor.defaultFormatter" = "Prisma.prisma";
			  };
			  "[go]" = {
			    "editor.defaultFormatter" = "golang.go";
			  };
			  "[rust]" = {
			    "editor.defaultFormatter" = "rust-lang.rust-analyzer";
			  };
			  "python.formatting.blackArgs" = ["--line-length" "120"];
			  "python.formatting.provider" = "black";
			  # Svelte
			  "svelte.enable-ts-plugin" = true;
			  # Tailwind
			  "tailwindCSS.experimental.classRegex" = [
			    "tw`([^`]*)"
			    "tw\\.style\\(([^)]*)\\)"
			  ];
			  # Ternimal
			  "terminal.integrated.defaultProfile.linux" = "fish";
			  "terminal.integrated.shellIntegration.enabled" = true;
			  "terminal.integrated.fontFamily" = "'JetBrains Mono'";
			  # Others
			  "emmet.includeLanguages" = {
			    "javascript" = "javascriptreact";
			  };
			  "git.enableSmartCommit" = true;
			  "git.autofetch" = true;
			  "github.gitAuthentication" = false;
			  "editor.linkedEditing" = true;
			  "explorer.confirmDragAndDrop" = false;
			  "git.confirmSync" = false;
			  "git.enableCommitSigning" = true;
			  "liveServer.settings.donotShowInfoMsg" = true;
			  "security.workspace.trust.untrustedFiles" = "open";
			  "prettier.enableDebugLogs" = true;
			  "editor.inlineSuggest.enabled" = true;
			  "editor.cursorBlinking" = "phase";
			  "editor.cursorSmoothCaretAnimation" = "on";
			  "vsicons.dontShowNewVersionMessage" = true;
			  "editor.unicodeHighlight.invisibleCharacters" = false;
			  "http.systemCertificates" = false;
			  "workbench.colorCustomizations" = {};
			  "thunder-client.codeSnippetLanguage" = "curl";
			  "go.toolsManagement.autoUpdate" = true;
			  "[astro]" = {
			    "editor.defaultFormatter" = "astro-build.astro-vscode";
			  };
			  "thunder-client.htmlView" = "Raw Html";
			  "editor.unicodeHighlight.allowedLocales" = {
			    "fr" = true;
			  };
			  "languageToolLinter.serviceType" = "public";
			  "workbench.layoutControl.enabled" = false;
			  "svelte.plugin.svelte.note-new-transformation" = false;
			  "git.openRepositoryInParentFolders" = "always";
			  "rust-analyzer.check.command" = "clippy";
			  "editor.largeFileOptimizations" = false;
			  "window.zoomLevel" = 1;
			  "[c]" = {
			    "editor.defaultFormatter" = "ms-vscode.cpptools";
			  };
		};
		extensions = with pkgs.vscode-extensions; [
			# Langages
			rust-lang.rust-analyzer
			golang.go
			yzhang.markdown-all-in-one
			bungcip.better-toml
			bradlc.vscode-tailwindcss
			astro-build.astro-vscode
			prisma.prisma
			svelte.svelte-vscode
			ms-vscode.cpptools
			jnoortheen.nix-ide
			ocamllabs.ocaml-platform
			# Theme
			mvllow.rose-pine
			pkief.material-icon-theme
			# useful
			esbenp.prettier-vscode
			james-yu.latex-workshop
			ritwickdey.liveserver
			dbaeumer.vscode-eslint
			usernamehw.errorlens
			mikestead.dotenv
			serayuzgur.crates
			adpyke.codesnap
			wix.vscode-import-cost
			formulahendry.auto-rename-tag
			naumovs.color-highlight
		];
	};
	
	programs.go = {
		enable = true;
		goPath = "Go";
	};
	
	# VM config
	dconf.settings = {
		"org/virt-manager/virt-manager/connections" = {
		autoconnect = ["qemu:///system"];
		uris = ["qemu:///system"];
		};
	};
	
	# Custom Desktop Apps
	xdg.desktopEntries = {
		random-folder = {
			name = "Random Folder";
			exec = "random-folder";
			terminal = false;
			type = "Application";
			icon = "/home/ilingu/Pictures/Others/Prog/ImgSite/icon-random-folder.png";
			comment = "Selects a random folder";
		};
		wl-color-picker = {
			name = "Color Picker";
			exec = "wl-color-picker";
			terminal = false;
			type = "Application";
			icon = "/home/ilingu/Pictures/Others/Icon/gpick-icon.png";
			comment = "Pick a color from your screen";
		};
	};
	
	# default apps
	home.sessionVariables = {
		EDITOR = "codium";
		#BROWSER = "brave";
		TERMINAL = "kitty";
	};
 
	# This value determines the Home Manager release that your
	# configuration is compatible with. This helps avoid breakage
	# when a new Home Manager release introduces backwards
	# incompatible changes.
	#
	# You can update Home Manager without changing this value. See
	# the Home Manager release notes for a list of state version
	# changes in each release.
	home.stateVersion = "23.05";
 };
}
