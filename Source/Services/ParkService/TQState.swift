//
// TQState.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

enum TQState<Value> {
    case loading
    case failure
    case result(Value)
}

