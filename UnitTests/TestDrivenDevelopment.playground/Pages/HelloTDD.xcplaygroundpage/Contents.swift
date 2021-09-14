import Foundation
import XCTest

class CashRegister {
    var availableFunds: Decimal
    var transactionTotal: Decimal = 0
    
    init(availableFunds: Decimal) {
        self.availableFunds = availableFunds
    }
    
    func additem(_ cost: Decimal) {
        self.transactionTotal += cost
    }
}
class CashRegisterTests: XCTestCase {
    var availableFunds: Decimal!
    var sut: CashRegister!
    var itemCost: Decimal!
    
    override func setUp() {
        super.setUp()
        availableFunds = 100
        itemCost = 42
        sut = CashRegister(availableFunds: availableFunds)
    }
    
    override func tearDown() {
        /*You should always nil any properties within tearDown() that you set within setUp(). This is due to the way the XCTest framework works: It instantiates each XCTestCase subclass within your test target, and it doesn’t release them until all of the test cases have run. Thereby, if you have a many test cases, and you don’t set their properties to nil within tearDown, you’ll hold onto the properties’ memory longer than you need. Given enough test cases, this can even cause memory and performance issues when running your tests
         */
        availableFunds = nil
        itemCost = nil
        sut = nil
        super.tearDown()
    }
    
    func testInitAvailableFunds_setsAvailableFunds() {
        XCTAssertEqual(sut.availableFunds, availableFunds)
    }
    
    func testAddItem_oneItem_addCostToTransactionTotal(){
        //when
        sut.additem(itemCost)
        //then
        XCTAssertEqual(sut.transactionTotal, itemCost)
    }
    
    func testAddItem_twoItems_addsCostsToTransactionTotal() {
        //given
        let itemCost2 = Decimal(20)
        let expectedTotal = itemCost + itemCost2
        
        //when
        sut.additem(itemCost)
        sut.additem(itemCost2)
        
        //then
        XCTAssertEqual(sut.transactionTotal, expectedTotal)
    }
}
CashRegisterTests.defaultTestSuite.run()
