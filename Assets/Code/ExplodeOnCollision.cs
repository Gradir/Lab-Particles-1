using UnityEngine;

public class ExplodeOnCollision : MonoBehaviour
{
	[SerializeField] GameObject explosionPrefab;

	private void OnTriggerEnter(Collider other)
	{
		var explosion = Instantiate(explosionPrefab);
		explosion.transform.position = transform.position;
		Destroy(gameObject);
	}
}
