using UnityEngine;
using System.Collections;

public class Breaths : MonoBehaviour {

	public static int CurrentBreaths { get; set; }

	public static Breaths Instance { get; private set; }

	void Awake(){
		Instance = this;
		CurrentBreaths = 0;
	}

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
