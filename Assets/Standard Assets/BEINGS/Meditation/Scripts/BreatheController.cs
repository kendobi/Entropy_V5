using UnityEngine;
using System.Collections;

public class BreatheController : MonoBehaviour {

	Animator animator;
	private bool pressed;
	private int numBreaths = -1;
	private float tapTime = 0.0f;
	private float timeSince = 0.0f;
	public float targetTime = 4.0f;

	public ParticleSystem vfx1;
	ParticleSystem.EmissionModule emissionModule1;
	public ParticleSystem vfx2;
	ParticleSystem.EmissionModule emissionModule2;
	public ParticleSystem vfx3;
	ParticleSystem.EmissionModule emissionModule3;

	public GameObject breatheOutObj;



	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator> ();
		pressed = false;
		emissionModule1 = vfx1.emission;
		emissionModule2 = vfx2.emission;
		emissionModule3 = vfx3.emission;

	}
	
	// Update is called once per frame
	void Update () {

		if (Input.GetMouseButtonUp (0)) {
				pressed = true;
			timeSince = Time.time - tapTime;

			if (timeSince >= targetTime) {
				if (numBreaths >= 0) {
					emissionModule1.rate = new ParticleSystem.MinMaxCurve (20.0f);
					breatheOutObj.SetActive (false);


				}
			}
		
			}
		if (Input.GetMouseButtonDown (0)) {
				pressed = false;
			tapTime = Time.time;

			if (numBreaths >= 0) {
					emissionModule1.rate = new ParticleSystem.MinMaxCurve (0.0f);
					breatheOutObj.SetActive (true);
				}
				timeSince = 0;

			numBreaths++;
			}
		if (numBreaths >= 0) {
			animator.SetBool ("isPressed", pressed);
			animator.SetInteger ("numBreaths", numBreaths);
		}
	}



	void Activate (int breaths){



	}
}
