//
//  CalendarViewController.swift
//  JScout
//
//  Created by Daniele Lanzetta on 30.11.17.
//  Copyright © 2017 Daniele Lanzetta. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {

    let formatter = DateFormatter()
    let monthColor = UIColor.yellow
    let selectedMonthColor = UIColor.black
    let outsideMonthColor = UIColor.gray
    
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
    }
    
    
    func setupCalendarView(){
        // Setup Spaces
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        // Setup Labels
        
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from:visibleDates)
        }
        
    }

    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        print (month.text!)
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "mmmm"
        self.month.text = self.formatter.string(from: date)
        
        
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate,JTAppleCalendarViewDataSource {
    
    func handleCellTextColor(view:JTAppleCell?, cellState:CellState) {
        
        guard let validCell = view as? CustomCell else {return}
        if cellState.isSelected {
            validCell.calendarDateLabel.textColor = selectedMonthColor
            
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.calendarDateLabel.textColor = monthColor
                
            }
            else {
                validCell.calendarDateLabel.textColor = outsideMonthColor
                
            }
                
            }
            
        }
            
            
    
        

    
    func handleCellSelected(view:JTAppleCell?, cellState:CellState) {
        guard let validCell = view as? CustomCell else {return}
        if validCell.isSelected {
            
            validCell.calendarSelectedView.isHidden = false
        }else {
            
            validCell.calendarSelectedView.isHidden = true
        }
        
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCell
        
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")
        let endDate = formatter.date(from: "2028 12 31")
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
    
   
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCell
        cell.calendarDateLabel.text = cellState.text
       handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
     setupViewsOfCalendar(from: visibleDates)
        
    }
    
    
}


extension CalendarViewController {
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
      handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
}
