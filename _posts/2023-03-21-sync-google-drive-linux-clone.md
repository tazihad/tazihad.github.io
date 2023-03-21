---
title: Sync Google Drive in Linux using rclone
---

Google Drive doesn't have any official linux client. Over the years many unofficial method was used to integrate google drive in linux. Mounting as file system or KDE and Gnome's Google Drive mount. But none of them sync like official client in windows. What we want is two way sync.  

We will achieve this with `rclone` feature called [bisync](https://rclone.org/bisync/).  
Make sure to install `rclone` in your linux distro Using `sudo apt install rclone` or `sudo dnf install rclone` depending if you use debian based system or fedora.  

1. First step is we need to login to Google Drive. The initial setup for drive involves getting a token from Google drive which you need to do in your browser. `rclone config` walks you through it.   
Here is an example of how to make a remote called `remote`. First run:  

   ```
   rclone config
   ```  
   This will guide you through an interactive setup process:  

   ```
   No remotes found, make a new one?
   n) New remote
   r) Rename remote
   c) Copy remote
   s) Set configuration password
   q) Quit config
   n/r/c/s/q> n
   name> remote
   Type of storage to configure.
   Choose a number from below, or type in your own value
   [snip]
   XX / Google Drive
   \ "drive"
   [snip]
   Storage> drive
   Google Application Client Id - leave blank normally.
   client_id>
   Google Application Client Secret - leave blank normally.
   client_secret>
   Scope that rclone should use when requesting access from drive.
   Choose a number from below, or type in your own value
   1 / Full access all files, excluding Application Data Folder.
   \ "drive"
   2 / Read-only access to file metadata and file contents.
   \ "drive.readonly"
   / Access to files created by rclone only.
   3 | These are visible in the drive website.
   | File authorization is revoked when the user deauthorizes the app.
   \ "drive.file"
   / Allows read and write access to the Application Data folder.
   4 | This is not visible in the drive website.
   \ "drive.appfolder"
   / Allows read-only access to file metadata but
   5 | does not allow any access to read or download file content.
   \ "drive.metadata.readonly"
   scope> 1
   Service Account Credentials JSON file path - needed only if you want use SA instead of interactive login.
   service_account_file>
   Remote config
   Use web browser to automatically authenticate rclone with remote?
   * Say Y if the machine running rclone has a web browser you can use
   * Say N if running rclone on a (remote) machine without web browser access
   If not sure try Y. If Y failed, try N.
   y) Yes
   n) No
   y/n> y
   If your browser doesn't open automatically go to the following link: http://127.0.0.1:53682/auth
   Log in and authorize rclone for access
   Waiting for code...
   Got code
   Configure this as a Shared Drive (Team Drive)?
   y) Yes
   n) No
   y/n> n
   --------------------
   [remote]
   client_id = 
   client_secret = 
   scope = drive
   root_folder_id = 
   service_account_file =
   token = {"access_token":"XXX","token_type":"Bearer","refresh_token":"XXX","expiry":"2014-03-16T13:57:58.955387075Z"}
   --------------------
   y) Yes this is OK
   e) Edit this remote
   d) Delete this remote
   y/e/d> y
   ```


2. Then we will create a test file called `RCLONE_TEST`. We will put this file in google drive `root` directory  using a browser to check access. This is a `rclone` feature for safety measure.  
You can create this file as `touch RCLONE_TEST` from terminal.  
3. Next we will sync our drive in a local folder. Let's create a `mydrive` folder in our home directory.  
   ```
   mkdir -p ~/mydrive
   ```
   Now use the following command:  
   ```
   rclone bisync "remote:/" "/home/zihad/mydrive/" --check-access --fast-list --drive-skip-shortcuts --drive-acknowledge-abuse --drive-skip-gdocs --drive-skip-dangling-shortcuts --verbose --resync
   ```  
   Note that we are skipping `Google docs`. Because `rclone` has yet to resolve the [issue](https://github.com/rclone/rclone/issues/5696).   
    If everything was correct you will see your google drive content in the `mydrive` directory.  Change to your username.  
     
4. Now let's automate the command using `systemd`.  Create `~/.config/systemd/user` directory if it doesn't exist.  
   ```
   mkdir -p ~/.config/systemd/user
   ```
   In the directory create a file called `sync-google-drive-rclone.timer`. And paste below:  
   ```
   [Unit]
   Description=sync google drive with rclone every 5 minutes.
   
   [Timer]
   OnCalendar=*:0/05
   Persistent=true
   
   [Install]
   WantedBy=timers.target

   ```  
   Note that `0.05` means we will sync our directory every 5 minutes.  
   
   Create another service file called `sync-google-drive-rclone.service`. Paste below code, Make sure to change username:   
   ```
   [Unit]
   Description=sync google drive with rclone every 5 minutes.
   
   [Service]
   ExecStart=rclone bisync "google-drive:/" "/home/zihad/mydrive/" --check-access --fast-list --drive-skip-shortcuts --drive-acknowledge-abuse --drive-skip-gdocs --drive-skip-dangling-shortcuts
   ```
   
   Let's enable the service from command line.
   ```  
   systemctl enable --user sync-google-drive-rclone.timer
   systemctl start --user sync-google-drive-rclone.timer
   ```
   Test if the service is enabled.  
   ```
   systemctl list-timers --user
   ```
   That's it now google drive will sync in every 5 minutes.
