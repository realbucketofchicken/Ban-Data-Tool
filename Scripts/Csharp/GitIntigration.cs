using Godot;
using LibGit2Sharp;
using LibGit2Sharp.Handlers;
using System;
using System.IO;
using System.Linq;

public partial class GitIntigration:Node{
	[Export] Button commit_button;
	[Export] Window options_window;
	[Export] Node Main;
	[Export] Label Push_error;
	[Export] Control Push_Base;
	[Export] Button pull_button;
	public override void _Ready()
	{
		base._Ready();
		commit_button.Pressed += Commit_changes;
		pull_button.Pressed += pull;
		Button edit = (Button)options_window.Get("clone_repo_button");
		if (edit != null){
			edit.Pressed += Clone;
		}
		Button reset_button = (Button)options_window.Get("reset_repo_button");
		if (reset_button != null){
			reset_button.Pressed += reset;
		}
	}

	void delete_recursive(String path){
		Godot.DirAccess current_access = Godot.DirAccess.Open(path);
		current_access.IncludeHidden = true;
		foreach (String Dir in current_access.GetDirectories()){
			//GD.Print("found " + path.PathJoin(Dir));
			delete_recursive(path.PathJoin(Dir));
		}
		foreach (String file in current_access.GetFiles()){
			//GD.Print("found file " + file);
			current_access.Remove(file);
		}
		DirAccess.RemoveAbsolute(path);
	}

	public void Clone(){
		Label edit = (Label)options_window.Get("clone_log");
		string path = ProjectSettings.GlobalizePath("user://repo/");
		if (Godot.DirAccess.DirExistsAbsolute(path)){
			GD.Print("ADAD");
			delete_recursive(path);
			DirAccess.RemoveAbsolute(path);
		}
		try {
			Repository.Clone(get_repo(), path);
		}
		catch(Exception e){
			GD.Print("Cloning failed, " + e.Message);
			if (edit != null){
				edit.Text = "Cloning failed, " + e.Message;
			}
			return;
		}
		if (edit != null){
			edit.Text = "Success! Repo cloned at: " + path;
		}
		Main.CallDeferred("set_file",path+"blacklist.txt");
	}

	String get_repo(){
		LineEdit edit = (LineEdit)options_window.Get("repo_edit");
		if (edit != null){
			return edit.Text;
		}
		else{
			return null;
		}
	}
	
	String get_email(){
		LineEdit edit = (LineEdit)options_window.Get("email_edit");
		if (edit != null){
			return edit.Text;
		}
		else{
			return null;
		}
	}

	String get_name(){
		LineEdit edit = (LineEdit)options_window.Get("name_edit");
		if (edit != null){
			return edit.Text;
		}
		else{
			return null;
		}
	}

	String get_key(){
		LineEdit edit = (LineEdit)options_window.Get("key_edit");
		if (edit != null){
			return edit.Text;
		}
		else{
			return null;
		}
	}



	public void pull(){
		
		string path = ProjectSettings.GlobalizePath("user://repo/");
		Repository repo = new Repository(path);
		// Credential information to fetch
		LibGit2Sharp.PullOptions options = new LibGit2Sharp.PullOptions();
		options.MergeOptions = new MergeOptions();
		options.MergeOptions.CommitOnSuccess = true;
		options.MergeOptions.FileConflictStrategy = CheckoutFileConflictStrategy.Ours;
		options.FetchOptions = new FetchOptions();
		options.FetchOptions.CredentialsProvider = new CredentialsHandler(
			(url, usernameFromUrl, types) =>
				new UsernamePasswordCredentials()
				{
					Username = get_name(),
					Password = get_key()
				});

		// User information to create a merge commit
		var signature = new LibGit2Sharp.Signature(
			new Identity(get_name(), get_email()), DateTimeOffset.Now);

		// Pull
		try{
		Commands.Pull(repo, signature, options);
		}
		catch(Exception e){
			Push_error.Text = e.Message;
			Push_Base.Show();
			return;
		}
		Main.CallDeferred("set_file",path+"blacklist.txt");
	}

	public void reset(){
		GD.Print("Reset");
		string path = ProjectSettings.GlobalizePath("user://repo/");
		Repository repo = new Repository(path);
		Branch originMain = repo.Branches["origin/main"];
		repo.Reset(ResetMode.Hard, originMain.Tip);
		Main.CallDeferred("set_file",path+"blacklist.txt");
	}

	public void Commit_changes(){
		string path = ProjectSettings.GlobalizePath("user://repo");
		GD.Print("Try commit");
		Repository repo = new Repository(path);
		repo.Index.Add("blacklist.txt");
		repo.Index.Write();
		Signature author = new Signature(get_name(), get_email(), DateTime.Now);
		Signature committer = author;
		try{
		Commit commit = repo.Commit("Update Banlist", author, committer);
		}
		catch(Exception e){
			Push_error.Text = e.Message;
			Push_Base.Show();
			return;
		}

		LibGit2Sharp.PushOptions options = new LibGit2Sharp.PushOptions();
		options.CredentialsProvider = new CredentialsHandler(
			(url, usernameFromUrl, types) =>
				new UsernamePasswordCredentials()
				{
					Username = get_name(),
					Password = get_key()
				});
		try{
			repo.Network.Push(repo.Branches["main"], options);
		}
		catch(Exception e){
			Push_error.Text = e.Message;
			Push_Base.Show();
			return;
		}

		//repo.Commit("Update banlist");
	}
}
