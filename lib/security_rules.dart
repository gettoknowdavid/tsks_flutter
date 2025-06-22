/**
 *
 *
    rules_version = '2';

    service cloud.firestore {
    match /databases/{database}/documents {
    // Helper Functions

    // Checks if the requesting user is the owner of the document
    function isOwner(userUid) {
    return request.auth != null && request.auth.uid == userUid;
    }

    // Checks if the requesting user is the creator of the collection
    function isAuthenticated() {
    return request.auth != null;
    }

    // Checks if the requesting user is a collaborator on the collection
    function isCreator(collectionId) {
    return isAuthenticated() && request.auth.uid == get(/databases/$(database)/documents/collections/$(collectionUid)).data.creatorId;
    }

    // Checks if the requesting user is a collaborator on the collection
    // function isCollaborator(collectionUid) {
    //     return isAuthenticated() && request.auth.uid in get(/databases/$(database)/documents/collections/$(collectionUid)).data.collaborators;
    // }

    // Checks if the user has read access to the collection (creator or collaborator)
    function canReadCollection(collectionUid) {
    return isCreator(collectionUid);
    }

    // Validates the schema for a new collection
    function isValidNewCollection(data) {
    return data.keys().hasOnly(['creatorId', 'title', 'isFavourite', 'colorARGB', 'iconMap', 'createdAt', 'updatedAt'])
    && data.creatorId == request.auth.uid
    && data.title is string && data.title.size() > 0 && data.title.size() < 100
    && (data.isFavourite == null || data.isFavourite is bool)
    && (data.colorARGB == null || data.colorARGB is int)
    && (data.iconMap == null || data.iconMap is map)
    && data.createdAt == request.time
    && data.updatedAt == request.time;
    }

    // Validates the schema for an updated collection
    function isValidUpdateCollection(data, currentData) {
    return (!('creatorId' in data) || data.creatorId == currentData.creatorId)
    && (!('title' in data) || (data.title is string && data.title.size() > 0 && data.title.size() < 100))
    && (!('isFavourite' in data) || data.isFavourite is bool)
    && (!('colorARGB' in data) || data.colorARGB == null || data.colorARGB is int)
    && (!('iconMap' in data) || data.iconMap == null || data.iconMap is map)
    && ('updatedAt' in data && data.updatedAt == request.time);
    }

    // Validates the schema for a new Task
    function isValidTaskSchema(data) {
    return data.title is string && data.title.size() > 0 && data.title.size() < 500
    && (data.isDone == null || data.isDone is bool)
    && (data.dueDate == null || data.dueDate is timestamp)
    && data.collectionUid is string
    && data.createdAt == request.time
    && data.updatedAt == request.time
    && (data.parentTask == null || data.parentTask is string)
    && (data.assignee == null || data.assignee is string);
    }

    // Validates the schema for an updated Task
    function isValidUpdateTaskSchema(data) {
    return (!('title' in data) || (data.title is string && data.title.size() > 0 && data.title.size() < 500))
    && (!('isDone' in data) || data.isDone is bool)
    && (!('dueDate' in data) || data.dueDate is timestamp || data.dueDate == null)
    && (!('assignee' in data) || data.assignee is string || data.assignee == null)
    && ('updatedAt' in data && data.updatedAt == request.time);
    }

    // User Data Path
    match /users/{userUid} {
    // Users can only access their own document
    allow read, write: if isOwner(userUid);
    }

    match /collections/{collectionUid} {
    allow read, delete: if isOwner(userUid);

    // On create, user must be owner and schema must be valid
    allow create: if isOwner(userUid) && isValidNewCollection(request.resource.data);

    // On update, user must be owner and cannot change owner or creation data
    allow update: if isOwner(userUid)
    && isValidUpdateCollection(request.resource.data)
    && request.resource.data.ownerUid == resource.data.ownerUid
    && request.resource.data.createdAt == resource.data.createdAt;

    match /todos/{todoUid} {
    allow read, delete: if isOwner(userUid);

    allow create: if isOwner(userUid)
    && isValidTodoSchema(request.resource.data)
    // Ensure only valid keys for a top-level todo are present.
    // We account for parentTodoUid being present but explicitly null.
    && request.resource.data.keys().hasOnly(['ownerUid', 'collectionUid', 'title', 'isDone', 'dueDate', 'parentTodoUid', 'createdAt', 'updatedAt'])
    && request.resource.data.ownerUid == userUid
    && request.resource.data.collectionUid == collectionUid
    && request.resource.data.parentTodoUid == null
    && exists(/databases/$(database)/documents/users/$(userUid)/collections/$(collectionUid));


    allow update: if isOwner(userUid) && isValidUpdateTodoSchema(request.resource.data);

    // Match sub-todos within this top-level todo
    match /subTodos/{subTodoUid} {
    allow read, delete: if isOwner(userUid);

    allow create: if isOwner(userUid)
    && isValidTodoSchema(request.resource.data)
    && request.resource.data.keys().hasOnly(['ownerUid', 'collectionUid', 'title', 'isDone', 'dueDate', 'parentTodoUid', 'createdAt', 'updatedAt'])
    && request.resource.data.ownerUid == userUid
    && request.resource.data.collectionUid == collectionUid
    && request.resource.data.parentTodoUid == todoUid;

    allow update: if isOwner(userUid) && isValidUpdateTodoSchema(request.resource.data);

    // ** CRITICAL: PREVENT ANY FURTHER NESTING **
    // This rule explicitly denies any read or write operations
    // for documents or sub-collections nested below a sub-todo.
    match /{path=**} {
    allow read, write: if false;
    }
    }
    }
    }
    }
    }
    }
 */
