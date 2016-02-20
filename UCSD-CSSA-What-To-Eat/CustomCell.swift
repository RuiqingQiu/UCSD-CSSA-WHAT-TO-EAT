
import UIKit

protocol CustomCellDelegate {
    
    //func maritalStatusSwitchChangedState(isOn: Bool)
    
    //func textfieldTextWasChanged(newText: String, parentCell: CustomCell)
    

}

class CustomCell: UITableViewCell, UITextFieldDelegate {

    // MARK: IBOutlet Properties

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var categoryCheckButton: UIButton!
    
    @IBOutlet weak var categoryDownButton: UIButton!
    
    @IBOutlet weak var itemLabel: UILabel!

    @IBOutlet weak var itemCheckButton: UIButton!
    
    
    // MARK: Constants
    
    let bigFont = UIFont(name: "Avenir-Book", size: 17.0)
    
    let smallFont = UIFont(name: "Avenir-Light", size: 17.0)
    
    let primaryColor = UIColor.blackColor()
    
    let secondaryColor = UIColor.lightGrayColor()
    
    
    // MARK: Variables
    
    var delegate: CustomCellDelegate!
    
    var row:Int = 0
    var section:Int = 0
    //var checked:Bool = false
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        if textLabel != nil {
            textLabel?.font = bigFont
            //textLabel?.textColor = primaryColor
        }
        
        if detailTextLabel != nil {
            detailTextLabel?.font = smallFont
            //detailTextLabel?.textColor = secondaryColor
        }
        

        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
