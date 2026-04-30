using Godot;
using System;
using System.Net.Http;
public partial class ServerStatGetter : Node
{
	[Export] String resulting_txt = "";
	public override void _Ready()
	{
		using(var client = new System.Net.Http.HttpClient()){
			var endp = new Uri("https://tfvr-server.fly.dev/sessions");
			var result = client.GetAsync(endp).Result;
			var json = result.Content.ReadAsStringAsync();
			GD.Print("BULL SHIT:",json.Result);
			resulting_txt = json.Result;
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
