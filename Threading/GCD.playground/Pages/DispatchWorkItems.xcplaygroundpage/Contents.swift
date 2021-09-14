import Foundation

//The main Queue
let mainQueue = DispatchQueue.main
//A Serial private queue
let userQueue = DispatchQueue.global(qos: .userInitiated)

func task1(){
    print("Task 1 started")
    sleep(4)
    print("mainThread:\(Thread.isMainThread)")
    print("Task 1 finished")
}

func task2(){
    print("Task 2 started")
    print("Task 2 finished")
}


// Running task 1 as dispatchWorkItem
print("---Running task 1 as dispatchWorkItem")
let workItem = DispatchWorkItem(block: {
    task1()
})
userQueue.async(execute: workItem)

// if the current thread really needs work item to finish before it can continue (dispatching Synchronously) call wait to tell the system to give it priority. If neccesary or possible, the system will icnrease the priority of other tasks in the same queue. It doesn't do this when you wait for dispatch groups or semaphores.
 
if workItem.wait(timeout: .now() + 3) == .timedOut {
    print("mainThread:\(Thread.isMainThread)")
    print("I got tired of waiting")
} else {
    print("Work item completed")
}

// With work items you can declare simple dependencies

let backgroundWorkItem = DispatchWorkItem {
    task1()
}
let updateUIWorkItem = DispatchWorkItem{
    task2()
}

userQueue.async(execute: backgroundWorkItem)
backgroundWorkItem.notify(queue: mainQueue, execute: updateUIWorkItem)


