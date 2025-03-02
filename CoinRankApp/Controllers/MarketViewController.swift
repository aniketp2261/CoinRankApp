//
//  MarketViewController.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 01/03/25.
//

import UIKit
import Charts
import SDWebImageSVGCoder

class MarketViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var statsCryptoMCapLbl: UILabel!
    @IBOutlet weak var statsVolumeLbl: UILabel!
    @IBOutlet weak var statsAllCoinsLbl: UILabel!

    @IBOutlet weak var tabCoinBtn: UIButton!
    @IBOutlet weak var tabFavBtn: UIButton!

    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var hVolumeBtn: UIButton!
    @IBOutlet weak var coinTableView: UITableView!
    
    private var coins: [Coin] = []
    private var limit = 20
    private var offset = 0
    private var priceOrder = true
    private var volumeOrder = true
    private var queryParam = "", uuid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        coinTableView.delegate = self
        coinTableView.dataSource = self
        priceBtn.layer.cornerRadius = priceBtn.bounds.height/2
        hVolumeBtn.layer.cornerRadius = hVolumeBtn.bounds.height/2
        mainView.layer.cornerRadius = 18
        mainView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        statsView.layer.cornerRadius = 18
        APICALL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func favTabClick(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func priceBtnClick(){
        offset = 0
        coins.removeAll()
        var order = "asc"
        if priceOrder {
            priceOrder.toggle()
            order = "asc"
            priceBtn.setTitle(" Price↓ ", for: .normal)
        } else {
            priceOrder.toggle()
            order = "desc"
            priceBtn.setTitle(" Price↑ ", for: .normal)
        }
        queryParam = "&orderBy=price&orderDirection=\(order)"
        APICALL()
    }
    
    @IBAction func volumeBtnClick(){
        offset = 0
        coins.removeAll()
        var order = "asc"
        if volumeOrder {
            volumeOrder.toggle()
            order = "asc"
            hVolumeBtn.setTitle(" 24h↓ ", for: .normal)
        } else {
            volumeOrder.toggle()
            order = "desc"
            hVolumeBtn.setTitle(" 24h↑ ", for: .normal)
        }
        queryParam = "&orderBy=24hVolume&orderDirection=\(order)"
        APICALL()
    }
    
    private func APICALL(){
        LoaderManager.shared.showLoader()
        APIService.shared.GetRequest(url: APIEndpoint.coinList + "?limit=\(limit)&offset=\(offset)\(queryParam)") { Res, error in
            if let res = Res {
                if let loaded = try? JSONDecoder().decode(CoinListModel.self, from: res) {
                    if loaded.status == "success" {
                        self.coins.append(contentsOf: loaded.data?.coins ?? [])
                        DispatchQueue.main.async {
                            LoaderManager.shared.hideLoader()
                            self.statsCryptoMCapLbl.text = self.formattedPrice(Double(loaded.data?.stats?.totalMarketCap ?? "0") ?? 0.0) + " " + self.formattedPrice(Double(loaded.data?.stats?.totalExchanges ?? 0))
                            self.statsVolumeLbl.text = self.formattedPrice(Double(loaded.data?.stats?.total24HVolume ?? "0") ?? 0.0)
                            self.statsAllCoinsLbl.text = String(loaded.data?.stats?.totalCoins ?? 0)
                            self.coinTableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            LoaderManager.shared.hideLoader()
                            print("APIError--",error?.localizedDescription ?? "")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                LoaderManager.shared.hideLoader()
            }
        }
    }
    
    private func FavAPICALL(){
        APIService.shared.PostRequest(url: APIEndpoint.favorite, body: ["coinUuid":uuid]) { Res, error in
            if let res = Res {
//                if let loaded = try? JSONDecoder().decode(CoinListModel.self, from: res) {
//                    if loaded.status == "success" {
//                        self.coins.append(contentsOf: loaded.data?.coins ?? [])
//                        DispatchQueue.main.async {
//                            self.statsCryptoMCapLbl.text = self.formattedPrice(Double(loaded.data?.stats?.totalMarketCap ?? "0") ?? 0.0) + " " + self.formattedPrice(Double(loaded.data?.stats?.totalExchanges ?? 0))
//                            self.statsVolumeLbl.text = self.formattedPrice(Double(loaded.data?.stats?.total24HVolume ?? "0") ?? 0.0)
//                            self.statsAllCoinsLbl.text = String(loaded.data?.stats?.totalCoins ?? 0)
//                            self.coinTableView.reloadData()
//                        }
//                    } else {
//                        print("APIError--",error?.localizedDescription ?? "")
//                    }
//                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            self.offset += 20
            self.APICALL()
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
    
}

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell", for: indexPath) as? CoinTableViewCell {
            let data = coins[indexPath.row]
            cell.coinImg.layer.cornerRadius = cell.coinImg.bounds.height/2
            cell.coinRankLbl.text = String(data.rank ?? 0)
            let icon = URL(string:(data.iconURL ?? "").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
            if icon?.pathExtension == "svg" {
                cell.coinImg.sd_setImage(with: icon, placeholderImage: nil, options: [], context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
            } else {
                cell.coinImg.sd_setImage(with: icon, placeholderImage: nil, options: [])
            }
            cell.layoutIfNeeded()
            cell.coinTitleLbl.text = data.name ?? "-"
            cell.coinSubTitleLbl.text = data.symbol ?? "-"
            cell.coinPriceLbl.text = formattedPrice(Double(data.price ?? "0") ?? 0.0)
            cell.coinSubPriceLbl.text = formattedPrice(Double(data.btcPrice ?? "0") ?? 0.0)
            cell.coinVolumeLbl.text = (data.lowVolume ?? false == false) ? String(format: "+%.2f", Double(data.change ?? "0") ?? 0.0) : String(format: "-%.2f", Double(data.change ?? "0") ?? 0.0)
            cell.coinVolumeLbl.textColor = (data.lowVolume ?? false == false) ? UIColor.green : UIColor.red
            cell.volImg.image = (data.lowVolume ?? false == false) ? UIImage(named: "high") : UIImage(named: "low")
            cell.addBottomShadow(cell.mainView)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoinDetailsViewController") as? CoinDetailsViewController {
            vc.uuid = coins[indexPath.row].uuid ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favouriteAction = UITableViewRowAction(style: .normal, title: "Favourite") { (action, indexPath) in
            self.uuid = self.coins[indexPath.row].uuid ?? ""
            self.FavAPICALL()
        }
        favouriteAction.backgroundColor = .systemYellow
        return [favouriteAction]
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        coinTableView.setEditing(editing, animated: animated)
        coinTableView.reloadData()
    }
}

extension UIImageView {
    func downloadedURL(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedURL(from: url, contentMode: mode)
    }
}
