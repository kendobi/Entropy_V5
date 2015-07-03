using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class PlayAudio : MonoBehaviour {
	void Start() {
		GetComponent<AudioSource>().Play();
		//audio.Play(44100);
	}
}