using UnityEngine;
using System.Collections;

public class FigureController : MonoBehaviour {

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
		if (Input.GetMouseButtonUp (0)) {
			pressed = false;
		}
		if (Input.GetMouseButtonDown (0)) {
			pressed = true;
			numBreaths++;


		}
		animator.SetBool ("isPressed", pressed);
		animator.SetInteger ("numBreaths", numBreaths);
	}
}
