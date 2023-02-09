using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using FlutterUnityIntegration;


public class LevelController : MonoBehaviour {
    [SerializeField]
    string _nextLevelName;

    Monster[] _monsters;

    void OnEnable() {
        _monsters = FindObjectsOfType<Monster>();
    }

    // Update is called once per frame
    void Update() {
        if (MonstersAreAllDead()) {
            GoToNextLevel();
        }
    }

    bool MonstersAreAllDead() {
        foreach (var monster in _monsters) {
            if (monster.gameObject.activeSelf) {
                return false;
            }
        }
        return true;
    }

    void GoToNextLevel() {
        Debug.Log("Go to level " + _nextLevelName);
        UnityMessageManager.Instance.SendMessageToFlutter("Go to level " + _nextLevelName);
        SceneManager.LoadScene(_nextLevelName);
    }
    public void ChangeCurrentLevel(String message){
        _nextLevelName = message;
        SceneManager.LoadScene(_nextLevelName);
    }
}