using UnityEngine;
using System.Collections;

public class BreatheController : MonoBehaviour {

	Animator animator;
	private bool pressed;
	private int numBreaths = 0;

	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator> ();
		pressed = false;
	
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown (0)) {
			pressed = true;
		}
		if (Input.GetMouseButtonUp (0)) {
			pressed = false;
			numBreaths++;

		}
		animator.SetBool ("isPressed", pressed);
		animator.SetInteger ("numBreaths", numBreaths);
	}
}
