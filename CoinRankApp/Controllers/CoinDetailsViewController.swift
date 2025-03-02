//
//  CoinDetailsViewController.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 01/03/25.
//

import UIKit
import Charts
import SDWebImageSVGCoder

class CoinDetailsViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var coinImg: UIImageView!
    @IBOutlet weak var coinNameLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var rankLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var subPriceLbl: UILabel!
    @IBOutlet weak var volumeLbl: UILabel!
    @IBOutlet weak var volumeImg: UIImageView!
    @IBOutlet weak var chartLineView: UIView!
    @IBOutlet weak var tradeBtn: UIButton!
    @IBOutlet weak var swapBtn: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var linkStackView: UIStackView!

    @IBOutlet weak var whatCoinLbl: UILabel!
    @IBOutlet weak var coinDescLbl: UILabel!
    @IBOutlet weak var statsCryptoMCapLbl: UILabel!
    @IBOutlet weak var statsVolumeLbl: UILabel!
    @IBOutlet weak var statsCoinsLbl: UILabel!
    @IBOutlet weak var supplyVerifyBtn: UIButton!
    @IBOutlet weak var supplyCirculatingLbl: UILabel!
    @IBOutlet weak var supplyTotalLbl: UILabel!
    @IBOutlet weak var supplyMaxLbl: UILabel!
    @IBOutlet weak var contractAddrTBV: UITableView!
    @IBOutlet weak var addStatsAllTimeLbl: UILabel!
    @IBOutlet weak var addStatsVolumeLbl: UILabel!
    @IBOutlet weak var addStatsPriceBTCLbl: UILabel!
    @IBOutlet weak var addStatsListingLbl: UILabel!
    
    lazy var lineChartView: LineChartView = {
        let chartview = LineChartView()
        return chartview
    }()
    private var contractAddressArr: [String] = []
    private var chartEntry: [ChartDataEntry] = []
    private var links: [Link] = []
    private var sparkLineTime: [String] = ["1h", "3h", "12h", "24h", "7d", "30d", "3m", "1y", "3y", "5y"]
    var uuid = ""
    var queryParam = ""
    var selectedButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        contractAddrTBV.delegate = self
        contractAddrTBV.dataSource = self
        volumeImg.superview?.layer.cornerRadius = (volumeImg.superview?.bounds.height ?? 0)/2
        tradeBtn.layer.cornerRadius = tradeBtn.bounds.height/2
        swapBtn.layer.cornerRadius = swapBtn.bounds.height/2
        mainView.layer.cornerRadius = 18
        mainView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        addBottomShadow(statsCryptoMCapLbl.superview ?? UIView())
        addBottomShadow(supplyVerifyBtn.superview ?? UIView())
        addBottomShadow(contractAddrTBV.superview ?? UIView())
        addBottomShadow(addStatsAllTimeLbl.superview ?? UIView())
        self.linkStackView.axis = .horizontal
        self.linkStackView.spacing = 2
        self.linkStackView.alignment = .center
        self.btnStackView.axis = .horizontal
        self.btnStackView.spacing = 0.5
        self.btnStackView.alignment = .center
        self.btnStackView.layer.borderWidth = 0.5
        self.btnStackView.layer.borderColor = UIColor.white.cgColor
        self.btnStackView.layer.cornerRadius = 5
        for time in self.sparkLineTime {
            let button = UIButton(type: .system)
            button.setTitle(time, for: .normal)
            button.backgroundColor = UIColor(named: "ThemeColor")
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(self.timeBtnTapped(_:)), for: .touchUpInside)
            self.btnStackView.addArrangedSubview(button)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APICALL()
    }
    
    func setChartView(){
        DispatchQueue.main.async {
            self.lineChartView.delegate = self
            self.lineChartView.frame = CGRect(x: self.chartLineView.bounds.minX, y: self.chartLineView.bounds.minY, width: self.chartLineView.frame.width, height: self.chartLineView.frame.height)
            self.chartLineView.addSubview(self.lineChartView)
            let set = LineChartDataSet(entries: self.chartEntry)
            set.colors = [NSUIColor.green]  
            set.valueColors = [NSUIColor.white]
            set.lineWidth = 2.0
            let gradientColors = [UIColor.green.cgColor, UIColor.clear.cgColor] as CFArray
            let colorLocations: [CGFloat] = [1.0, 0.5]
            if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
                set.fill = LinearGradientFill(gradient: gradient,angle: 90.0)
            }
            set.drawCirclesEnabled = false
            set.drawFilledEnabled = true
            set.lineCapType = .round
            
            self.lineChartView.drawGridBackgroundEnabled = false
            self.lineChartView.data = LineChartData(dataSet: set)
            self.lineChartView.legend.enabled = false
            self.lineChartView.xAxis.centerAxisLabelsEnabled = true
            
            self.lineChartView.xAxis.drawLabelsEnabled = false
            self.lineChartView.leftAxis.drawLabelsEnabled = false
            self.lineChartView.rightAxis.drawLabelsEnabled = false

            self.lineChartView.xAxis.drawAxisLineEnabled = false
            self.lineChartView.leftAxis.drawAxisLineEnabled = false
            self.lineChartView.rightAxis.drawAxisLineEnabled = false
            
            self.lineChartView.xAxis.drawGridLinesEnabled = false
            self.lineChartView.leftAxis.drawGridLinesEnabled = false
            self.lineChartView.notifyDataSetChanged()
        }
    }
    
    @IBAction func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func APICALL(){
        LoaderManager.shared.showLoader()
        APIService.shared.GetRequest(url: APIEndpoint.coinDetail + uuid + queryParam, onCompletion: { Res, error in
            if let res = Res {
                if let loaded = try? JSONDecoder().decode(CoinDetailsModel.self, from: res) {
                    if loaded.status == "success" {
                        if let data = loaded.data?.coin {
                            DispatchQueue.main.async {
                                LoaderManager.shared.hideLoader()
                                self.contractAddressArr.append(contentsOf: data.contractAddresses ?? [])
                                self.coinImg.sd_setImage(with: URL(string: data.iconURL ?? ""))
                                self.coinNameLbl.text = data.name ?? "-"
                                self.rankLbl.text = "#\(data.rank ?? 0) \(data.symbol ?? "-")"
                                self.priceLbl.text = self.formattedPrice(Double(data.price ?? "0") ?? 0.0)
                                self.subPriceLbl.text = self.formattedPrice(Double(data.change ?? "0") ?? 0.0)
                                self.volumeLbl.text = (data.lowVolume ?? false == false) ? String(format: "+%.2f", Double(data.change ?? "0") ?? 0.0) : String(format: "-%.2f", Double(data.change ?? "0") ?? 0.0)
                                self.volumeLbl.textColor = (data.lowVolume ?? false == false) ? UIColor.green : UIColor.red
                                self.volumeImg.image = (data.lowVolume ?? false == false) ? UIImage(named: "chart-up")?.withTintColor(.green) : UIImage(named: "chart-down")?.withTintColor(.red)
                                self.whatCoinLbl.text = "What is \(data.name ?? "-")?"
                                self.coinDescLbl.text = data.description ?? "-"
                                self.statsCryptoMCapLbl.text = "\(self.formattedPrice(Double(data.price ?? "0") ?? 0.0))+\(String(format: "%.2f", Double(data.change ?? "0") ?? 0.0))%"
                                self.statsVolumeLbl.text = self.formattedPrice(Double(data.the24HVolume ?? "0") ?? 0.0)
                                self.supplyVerifyBtn.tintColor = data.supply?.confirmed == true ? UIColor.green : UIColor.red
                                self.supplyVerifyBtn.setTitle(data.supply?.confirmed == true ? "Verified" : "Not Verified", for: .normal)
                                self.statsCoinsLbl.text = "48,961"
                                self.supplyCirculatingLbl.text = self.formattedPrice(Double(data.supply?.circulating ?? "0") ?? 0.0)
                                self.supplyTotalLbl.text = self.formattedPrice(Double(data.supply?.total ?? "0") ?? 0.0)
                                self.supplyMaxLbl.text = self.formattedPrice(Double(data.supply?.max ?? "0") ?? 0.0)
                                let dayTimePeriodFormatter = DateFormatter()
                                dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY"
                                self.addStatsAllTimeLbl.text = self.formattedPrice(Double(data.allTimeHigh?.price ?? "0") ?? 0.0) + "(\(dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(data.allTimeHigh?.timestamp ?? 0)))))"
                                self.addStatsListingLbl.text = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(data.listedAt ?? 0)))
                                self.addStatsVolumeLbl.text = self.formattedPrice(Double(data.the24HVolume ?? "0") ?? 0.0)
                                self.addStatsPriceBTCLbl.text = self.formattedPrice(Double(data.btcPrice ?? "0") ?? 0.0)
                                self.contractAddrTBV.reloadData()
                                for (index, item) in (data.sparkline ?? []).enumerated() {
                                    let obj = ChartDataEntry(x: Double(index), y: (((Double(item) ?? 0.0)*100).rounded()/100) )
                                    self.chartEntry.append(obj)
                                    self.setChartView()
                                }
                                self.links = data.links ?? []
                                for link in self.links {
                                    let button = UIButton(type: .system)
                                    button.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
                                    button.setTitle(link.type ?? "", for: .normal)
                                    button.setTitleColor(UIColor.darkGray, for: .normal)
                                    button.addTarget(self, action: #selector(self.linkBtnTapped(_:)), for: .touchUpInside)
                                    self.linkStackView.addArrangedSubview(button)
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            LoaderManager.shared.hideLoader()
                            print("APIError--",error?.localizedDescription ?? "")
                        }
                    }
                }
            }
        })
    }
    
    @objc func linkBtnTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            print("\(title) was tapped!")
            for link in self.links {
                if title == link.type {
                    if let url = URL(string: link.url ?? "") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    @objc func timeBtnTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            print("\(title) was tapped!")
            DispatchQueue.main.async {
                self.queryParam = "?timePeriod=\(title)"
                self.lineChartView.data?.clearValues()
                self.chartEntry.removeAll()
                self.contractAddressArr.removeAll()
                self.links.removeAll()
                for subview in self.linkStackView.arrangedSubviews {
                    self.linkStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
                self.selectedButton?.backgroundColor = UIColor(named: "ThemeColor")
                self.selectedButton?.setTitleColor(.white, for: .normal)
                sender.backgroundColor = .clear
                sender.setTitleColor(.green, for: .normal)
                self.selectedButton = sender
                self.APICALL()
            }
        }
    }
    
    func formattedPrice(_ amount:Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        if amount >= 1_000_000_000_000 { // trillion
            let formattedAmount = amount / 1_000_000_000_000
            return "$\(numberFormatter.string(from: NSNumber(value: formattedAmount))!)T"
        } else if amount >= 1_000_000_000 { // billion
            let formattedAmount = amount / 1_000_000_000
            return "$\(numberFormatter.string(from: NSNumber(value: formattedAmount))!)B"
        } else if amount >= 1_000_000 { // million
            let formattedAmount = amount / 1_000_000
            return "$\(numberFormatter.string(from: NSNumber(value: formattedAmount))!)M"
        } else {
            return "$\(numberFormatter.string(from: NSNumber(value: amount))!)"
        }
    }

    func addBottomShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
    }
}
extension CoinDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contractAddressArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContractAddressTableViewCell", for: indexPath) as? ContractAddressTableViewCell {
            let data = contractAddressArr[indexPath.row]
            cell.addressLbl.text = data
            cell.copyBtn.addTarget(self, action: #selector(copyBtnTapped(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }

    @objc func copyBtnTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            print("\(title) was tapped!")
            UIPasteboard.general.string = title
        }
    }
}
