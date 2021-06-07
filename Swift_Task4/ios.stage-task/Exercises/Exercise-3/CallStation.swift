import Foundation

final class CallStation {
    // property
    var allUsers : [User] = []
    var allCalls  : [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        return allUsers
    }
    
    func add(user: User) {
        if  !allUsers.contains(user) {
            allUsers.append(user)
        }
    }
    
    func remove(user: User) {
        allUsers = allUsers.filter({$0 != user})
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case let .start(from:  userFrom, to: userTo):
            let callID = CallID()
            if !allUsers.contains(userFrom)  {
                return nil
            }
            if !allUsers.contains(userTo) {
                let call = Call(id: callID, incomingUser: userFrom, outgoingUser: userTo, status: .ended(reason: .error))
                allCalls.append(call)
                return callID
            }
            if currentCall(user: userTo) != nil {
                let call = Call(id: callID, incomingUser: userFrom, outgoingUser: userTo, status: .ended(reason: .userBusy))
                allCalls.append(call)
                return callID
            }
            let call = Call(id: callID, incomingUser: userFrom, outgoingUser: userTo, status: .calling)
            allCalls.append(call)
            return callID
        case let .answer(from: fromUser):
            let call = currentCall(user: fromUser)
            if !allUsers.contains(fromUser) {
                let callBreak = Call(id: call!.id, incomingUser: call!.incomingUser, outgoingUser: fromUser, status: .ended(reason: .error))
                allCalls.append(callBreak)
                allCalls.removeFirst()
                return nil
            }
            let callGood = Call(id: call!.id, incomingUser: call!.incomingUser, outgoingUser: fromUser, status: .talk)
            allCalls.append(callGood)
            allCalls.removeFirst()
            return call?.id
        case let .end(from: fromUser):
            let call = currentCall(user: fromUser)
            if call!.status != .talk {
                let callCancel = Call(id: call!.id, incomingUser: call!.incomingUser, outgoingUser: call!.outgoingUser, status: .ended(reason: .cancel))
                allCalls.append(callCancel)
                allCalls.removeFirst()
                return call?.id
            }
            let callEnd = Call(id: call!.id, incomingUser: call!.incomingUser, outgoingUser: call!.outgoingUser, status: .ended(reason: .end))
            allCalls.append(callEnd)
            allCalls.removeFirst()
            return call?.id
        }
            
    }
    
    func calls() -> [Call] {
        return allCalls
    }
    
    func calls(user: User) -> [Call] {
        let allTest = allCalls
        //print("all\(allTest)")
        let test = allCalls.filter({ $0.incomingUser.id == user.id || $0.outgoingUser.id == user.id })
        print("all 222 \(test.count)")
        
        return allCalls.filter({ $0.incomingUser.id == user.id || $0.outgoingUser.id == user.id })
    }
    
    func call(id: CallID) -> Call? {
        return allCalls.filter({ $0.id == id }).first
    }
    
    func currentCall(user: User) -> Call? {
        let call = allCalls.filter({ $0.incomingUser.id == user.id || $0.outgoingUser.id == user.id })
        let result = call.first
        if result?.status == .ended(reason: .end) || result?.status == .ended(reason: .cancel) || result?.status == .ended(reason: .error) || result?.status == .ended(reason: .userBusy) {
            return nil
        } else {
            return result
        }
    }
}
