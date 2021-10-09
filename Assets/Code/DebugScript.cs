using UnityEngine;

public class DebugScript : MonoBehaviour
{
	[SerializeField] GameObject projectilePrefab;
	[SerializeField] AudioClip mana;
	[SerializeField] AudioSource aus;
	GameObject spawnedProjectile;

	void Update()
	{
		if (Input.GetKeyUp(KeyCode.Space))
		{
			if (spawnedProjectile != null)
			{
				if (aus.isPlaying == false)
				{
					aus?.PlayOneShot(mana);
				}
			}
			else
			{
				SpawnProjectile();
			}
		}
	}

	public void SpawnProjectile()
	{
		spawnedProjectile = Instantiate(projectilePrefab);
	}
}
