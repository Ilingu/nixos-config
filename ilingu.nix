{ config, pkgs, ... }:

{
  # Define a user account.
  users.users.ilingu = {
    isNormalUser = true;
    description = "Ilingu";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ]; # enable sudo, network, medias, docker
    shell = pkgs.fish; # set default shell to fish

    packages = with pkgs; [
	brave
	gnome.gnome-tweaks
	gnome.iagno
	gnome.gnome-boxes
	gpick
	pika-backup
	gnome.gnome-power-manager
	bleachbit
	via
	veracrypt
	insomnia
	vscodium
	libreoffice
	audacity
	gimp
	#freetube -> freetube doesn't work with nix; I installed it via flatpak...
	newsflash
	vlc
	spotify
	mullvad-vpn
	qbittorrent
	tor-browser-bundle-bin
	gh
	# fish plugins
	fishPlugins.autopair
	fishPlugins.puffer
	fishPlugins.sponge
	fishPlugins.z
	fishPlugins.fzf
	# gnome extensions
	gnomeExtensions.pano
	gnomeExtensions.caffeine
	gnomeExtensions.desktop-icons-ng-ding
	gnomeExtensions.emoji-selector
	gnomeExtensions.openweather
	gnomeExtensions.search-light
	gnomeExtensions.top-bar-organizer
	gnomeExtensions.hide-activities-button
	gnomeExtensions.vitals
	gnomeExtensions.appindicator
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
		shellInit = ''starship init fish | source'';
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
 	
	home.sessionVariables = {
		EDITOR = "codium";
		#BROWSER = "brave";
		TERMINAL = "kitty";
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
	      	};
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
