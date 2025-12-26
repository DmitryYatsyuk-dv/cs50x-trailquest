//
// CompetitionManagedObjectModel.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import CoreData

enum CompetitionManagedObjectModel {
    static func makeModel() -> NSManagedObjectModel {
        let competition = makeCompetitionEntity()
        let visitedCheckpoint = makeVisitedCheckpointEntity()

        let visitedRelationship = NSRelationshipDescription()
        visitedRelationship.name = "visitedCheckpoints"
        visitedRelationship.destinationEntity = visitedCheckpoint
        visitedRelationship.deleteRule = .cascadeDeleteRule
        visitedRelationship.minCount = 0
        visitedRelationship.maxCount = 0
        visitedRelationship.isOrdered = true

        let competitionRelationship = NSRelationshipDescription()
        competitionRelationship.name = "competition"
        competitionRelationship.destinationEntity = competition
        competitionRelationship.deleteRule = .nullifyDeleteRule
        competitionRelationship.minCount = 1
        competitionRelationship.maxCount = 1

        visitedRelationship.inverseRelationship = competitionRelationship
        competitionRelationship.inverseRelationship = visitedRelationship

        competition.properties.append(visitedRelationship)
        visitedCheckpoint.properties.append(competitionRelationship)

        let model = NSManagedObjectModel()
        model.entities = [competition, visitedCheckpoint]
        return model
    }

    private static func makeCompetitionEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = Entities.competition
        entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)

        entity.properties = [
            makeUUIDAttribute(name: "id"),
            makeStringAttribute(name: "competitionUID"),
            makeIntegerAttribute(name: "parkID"),
            makeStringAttribute(name: "parkName"),
            makeDateAttribute(name: "startDate"),
            makeDateAttribute(name: "finishDate", isOptional: true),
            makeIntegerAttribute(name: "totalCheckpoints"),
            makeDateAttribute(name: "lastUpdatedAt"),
            makeDoubleAttribute(name: "progress"),
            makeStringAttribute(name: "difficulty", defaultValue: TQDifficulty.medium.rawValue)
        ]

        entity.uniquenessConstraints = [["id"]]
        return entity
    }

    private static func makeVisitedCheckpointEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = Entities.visitedCheckpoint
        entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)

        entity.properties = [
            makeUUIDAttribute(name: "id"),
            makeIntegerAttribute(name: "checkpointID"),
            makeIntegerAttribute(name: "sequenceNumber"),
            makeDateAttribute(name: "visitedAt"),
            makeDoubleAttribute(name: "latitude"),
            makeDoubleAttribute(name: "longitude"),
            makeStringAttribute(name: "checkpointName"),
            makeStringAttribute(name: "source", defaultValue: TQSource.manual.rawValue)
        ]

        entity.uniquenessConstraints = [["id"]]
        return entity
    }

    private static func makeUUIDAttribute(name: String, isOptional: Bool = false) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .UUIDAttributeType
        attribute.isOptional = isOptional
        return attribute
    }

    private static func makeStringAttribute(name: String, isOptional: Bool = false, defaultValue: String = "") -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .stringAttributeType
        attribute.isOptional = isOptional
        attribute.defaultValue = defaultValue
        return attribute
    }

    private static func makeDateAttribute(name: String, isOptional: Bool = false) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .dateAttributeType
        attribute.isOptional = isOptional
        return attribute
    }

    private static func makeIntegerAttribute(name: String, isOptional: Bool = false) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .integer64AttributeType
        attribute.isOptional = isOptional
        attribute.defaultValue = 0
        return attribute
    }

    private static func makeDoubleAttribute(name: String, isOptional: Bool = false) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .doubleAttributeType
        attribute.isOptional = isOptional
        attribute.defaultValue = 0.0
        return attribute
    }

    private enum Entities {
        static let competition = "Competition"
        static let visitedCheckpoint = "VisitedCheckpoint"
    }
}
