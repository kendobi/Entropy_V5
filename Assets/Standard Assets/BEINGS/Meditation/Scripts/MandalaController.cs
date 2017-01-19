using UnityEngine;
using System.Collections;

public class MandalaController : MonoBehaviour {


	private bool pressed;
	private int numBreaths = -1;
	public int bpl;

	public GameObject[] MandalaLayers;
	public GameObject BreatheOutVFX;

	ParticleSystem.EmissionModule emissionModule;

	// Use this for initialization
	void Start () {
		pressed = false;
		emissionModule = BreatheOutVFX.GetComponent<ParticleSystem>().emission;
	
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown (0)) {
			pressed = true;
		}
		if (Input.GetMouseButtonUp (0)) {
			pressed = false;
			Activate (BreatheOutController.numBreaths);
			BreatheOut ();


		}
	}

	void Activate (int breaths){
		print (breaths);
		if ((breaths % bpl == 0) && (breaths > 0)) {
			int currentLayer = breaths / bpl;

			for (int i = 0; i < MandalaLayers.Length; i++) {
				if (i == currentLayer) {
					MandalaLayers [i].SetActive (true);
				}
			}
		}

	}

	void BreatheOut(){
		//scale up
		StartCoroutine(LerpScale(2.0f, BreatheOutVFX, 0.1f));
		//StartCoroutine (LerpScale (4.0f, BreatheOutVFX, -0.1f));
		StartCoroutine(EmissionTimer(2.0f));

	}

	IEnumerator LerpScale(float time, GameObject go, float scaleAmount){
		//scales go up over time
		Vector3 originalScale = go.transform.localScale;
		Vector3 targetScale = originalScale + new Vector3 (scaleAmount, 0.0f, scaleAmount);
		float originalTime = time;

		while (time > 0.0f)
		{
			time -= Time.deltaTime;

			go.transform.localScale = Vector3.Lerp(targetScale, originalScale, (time / originalTime));
			yield return null;
		}

	}

	IEnumerator EmissionTimer(float time){
		float originalTime = time;

		while (time > 0.0f) {
			time -= Time.deltaTime;

			emissionModule.rate = new ParticleSystem.MinMaxCurve(2.0f);
			yield return null;
		
		}

		if (time <= 0.0f) {
		
			emissionModule.rate = new ParticleSystem.MinMaxCurve(0.0f);
		}

	}
}
