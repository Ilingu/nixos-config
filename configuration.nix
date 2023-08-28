# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Boot config
  boot = {
  	# boot to latest kernel
  	kernelPackages = pkgs.linuxPackages_latest;
  
  	# Default UEFI bootloader
  	loader.systemd-boot.enable = true;
	loader.efi.canTouchEfiVariables = true;
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-7e1bac6b-25da-41f5-8cba-31cda84806ac".device = "/dev/disk/by-uuid/7e1bac6b-25da-41f5-8cba-31cda84806ac";
  boot.initrd.luks.devices."luks-7e1bac6b-25da-41f5-8cba-31cda84806ac".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "ilingu"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant: do not enable it when networking.networkmanager is enabled.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  
  # Set fonts
  fonts.fonts = with pkgs; [
    fira-code
    nerdfonts
    jetbrains-mono
  ];
  
  # Enable automatic nix cleanup
  nix.settings.auto-optimise-store = true;
  nix.gc = {
  	automatic = true;
  	dates = "monthly";
  	options = "--delete-older-than 30d"; # deletes all the generations older than 30 days (I assume that if the current generations is stable for more than 30 days, it means it's stable
  };

  
  # Enable automatic NixOS upgrades
  system.autoUpgrade = {
  	enable = true;
	channel = "https://channels.nixos.org/nixos-23.05";
	dates = "daily";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
	  gnome-photos
	  gnome-tour
  ]) ++ (with pkgs.gnome; [
	  cheese # webcam tool
	  gnome-music
	  # gnome-terminal
	  # gedit # text editor
	  epiphany # web browser
	  geary # email reader
	  # evince # document viewer
	  # gnome-characters
	  totem # video player
	  #tali # poker game
	  #iagno # go game
	  #hitori # sudoku game
	  #atomix # puzzle game
  ]);

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable system76 drivers
  hardware.system76.enableAll = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  # Enable fish shell globally
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Flatpak Globally (for apps that doesn't works with nix or that just don't exists)
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    wget
    htop
    neofetch
    gnome-console
    gnupg
    pinentry
    pinentry-curses
    gnome.gnome-software # flatpak GUI
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

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
			cls = "clear";
			trash = "/home/ilingu/Prog/BashScript/trash.sh";
			#rm = "trash";
			explorer="nautilus";
			icat="kitty +kitten icat --align=left";
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
			user.signingkey = "8506535673F81374";
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
 
 # Overlays
 nixpkgs.overlays = [
 # it doesn't bump to the latest version at all, so for now freetube is installed via flatpak
 #	(self: super: {
 #		freetube = super.freetube.overrideAttrs (old: {
 #			src = super.fetchFromGitHub {
 #				owner = "FreeTubeApp";
 #				repo = "FreeTube";
 #				rev = "a8658a745dbd800494241bd5fcb6616b98aa3e21";
 #				#url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v0.19.0-beta/freetube_0.19.0_amd64.AppImage";
 #				sha256 = "sha256-+pDXG4sLTpS9dfVDGTNI/3LMq4PXHvbwzTrxYbrlu5g=";
 #			};
 #		});
 #	})
 ];
}
