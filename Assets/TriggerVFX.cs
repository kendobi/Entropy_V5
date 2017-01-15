using UnityEngine;
using System.Collections;

public class TriggerVFX : MonoBehaviour {

	public GameObject myVFX;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	void Activate (GameObject go){
		Instantiate (go);
	}
}
