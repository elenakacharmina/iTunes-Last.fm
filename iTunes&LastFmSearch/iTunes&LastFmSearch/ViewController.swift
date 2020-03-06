import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<MSection, MItem>?
    
    enum searchApi: Int {
        case iTunes = 0
        case lastFm
    }
    
    
    
    var searchBar: UISearchBar!
    
    var currentSearch: searchApi = .iTunes
    private let arrayMedia = ["music", "musicVideo"]
    var sections = [MSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesKeyboard()
        segmentedControl.addTarget(self, action: #selector(selectedValue), for: .valueChanged)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 36))
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MSection, MItem>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch self.sections[indexPath.section].type {
            case "music":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCell.reuseId, for: indexPath) as? SongCell
                cell?.configure(with: item)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicVideoCell.reuseId, for: indexPath) as? MusicVideoCell
                cell?.configure(with: item)
                return cell
            }
            
        })
        dataSource?.supplementaryViewProvider = { [weak self]
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {
                return nil
            }
            
            guard let firstSection = self?.dataSource?.itemIdentifier(for: indexPath) else {
                return nil
            }
            
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstSection) else {
                return nil
            }
            if section.title.isEmpty {
                return nil
            }
            sectionHeader.title.text = section.title
            
            return sectionHeader
            
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<MSection, MItem>()
        snapshot.appendSections(sections)
        if sections.count > 1 {
            if sections[1].type == "music" {
                let temp = sections[0]
                sections[0] = sections[1]
                sections[1] = temp
            }
        }
        
        
        for section in sections {
            snapshot.appendItems(section.results, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
    
    
    
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height - 200), collectionViewLayout: createCompositionalLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.register(SongCell.self, forCellWithReuseIdentifier: SongCell.reuseId)
        collectionView.register(MusicVideoCell.self, forCellWithReuseIdentifier: MusicVideoCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    }
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            switch section.type {
            case "music":
                return self.creatMusicSection()
            default:
                return self.creatMusicVideoSection()
            }
        }
        
        return layout
    }
    //
    func creatMusicSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 0, trailing: 0)
        
        let layoutGroupedSize = NSCollectionLayoutSize(widthDimension: .absolute(320), heightDimension: .absolute(224))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupedSize, subitem: layoutItem, count: 4)
        
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.orthogonalScrollingBehavior = .continuous
        
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 12, bottom: 26, trailing: 12)
        
        let header = createSectionHeader()
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    func creatMusicVideoSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 8, trailing: 0)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 12, bottom: 0, trailing: 12)
        
        let header = createSectionHeader()
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    
    @objc func selectedValue(target: UISegmentedControl) {
        print(sections)
        
        if target == self.segmentedControl {
            let segmentIndex = target.selectedSegmentIndex
            currentSearch = searchApi(rawValue: segmentIndex) ?? searchApi.iTunes
        }
    }
    
}



extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == self.searchBar {
            
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchText: String = searchBar.text ?? ""
        
        self.searchBar.endEditing(true)
        
        sections = []
        
        for kindOfMedia in arrayMedia {
            var link = ""
            
            switch currentSearch {
            case .iTunes:
                link = "https://itunes.apple.com/search?term=\(searchText)&media=\(kindOfMedia)&limit=20"
            default:
                link = "http://ws.audioscrobbler.com/2.0/?method=track.search&track=\(searchText)&api_key=2246b8efed6fe8f590ddddda32c0905b&format=json"
            }
            guard let url = URL(string: link) else { return }
            
            let session = URLSession.shared.dataTask(with: url) { data, _, error in
                guard error == nil else { return }
                
                guard let data = data else { return }
                
                //                do { let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                //                    print(jsonObject)
                //                } catch {
                //                    print(error)
                //                }
                
                switch self.currentSearch {
                case .iTunes:
                    self.recieveFromItunes(data: data, kindOfMedia: kindOfMedia)
                default:
                    self.recieveFromLastFm(data: data, kindOfMedia: kindOfMedia)
                }
            }
            session.resume()
        }
    }
}


extension ViewController {
    func recieveFromItunes(data: Data, kindOfMedia: String) {
        do {
            defer {
                DispatchQueue.main.async() {
                    self.reloadData()
                }
            }
            if let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any> {
                guard let _ = dict["resultCount"] as? Int else { return }
                
                if dict["resultCount"] as! Int == 0  {
                    DispatchQueue.main.async() {
                        self.alert(title: "Ошибка", message: "По вашему запросу ничего не найдено", style: .alert)
                    }
                    return
                }
                
                if let array = dict["results"] as? [Dictionary<String,Any>] {
                    
                    var items = [MItem]()
                    for element in array {
                        items.append(MItem(artistName: element["artistName"] as? String? ?? "", trackName: element["trackName"] as? String? ?? "", kind: element["kind"] as? String? ?? "", linkForImage: element["artworkUrl100"] as? String ?? ""))
                        
                    }
                    let section = MSection(type: kindOfMedia, title: kindOfMedia.prefix(1).uppercased() + kindOfMedia.dropFirst(), results: items)
                    
                    self.sections.append(section)
                }
            }
        }
        catch {
            print("error")
        }
    }
    
    
    func recieveFromLastFm(data: Data, kindOfMedia: String) {
        do {
            defer {
                DispatchQueue.main.async() {
                    self.reloadData()
                }
            }
            if let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any> {
                
                if let array = dict["results"] as? Dictionary<String,Any> {
                    
                    if array["opensearch:totalResults"] as! String == "0"  {
                        DispatchQueue.main.async() {
                            self.alert(title: "Ошибка", message: "По вашему запросу ничего не найдено", style: .alert)
                        }
                        return
                    }
                    var items = [MItem]()
                    if kindOfMedia == arrayMedia[0] {
                        if let arrayTrack = array["trackmatches"] as? Dictionary<String,Any> {
                            if let track = arrayTrack["track"] as? [Dictionary<String,Any>] {
                                for element in track {
                                    var link = ""
                                    if let image = element["image"] as? [Dictionary<String,Any>] {
                                        let d = image[0]
                                        link = d["#text"] as? String ?? ""
                                    }
                                    
                                    items.append(MItem(artistName: element["artist"] as? String? ?? "", trackName: element["name"] as? String? ?? "", kind: kindOfMedia, linkForImage: link))
                                }
                            }
                        }
                        let section = MSection(type: kindOfMedia, title: kindOfMedia.prefix(1).uppercased() + kindOfMedia.dropFirst(), results: items)
                        self.sections.append(section)
                    } else {
                        if let arrayTrack = array["trackmatches"] as? Dictionary<String,Any> {
                            if let track = arrayTrack["track"] as? [Dictionary<String,Any>] {
                                for element in track {
                                    var link = ""
                                    if let image = element["image"] as? [Dictionary<String,Any>] {
                                        let d = image[0]
                                        link = d["#text"] as? String ?? ""
                                    }
                                    
                                    items.append(MItem(artistName: element["artist"] as? String? ?? "", trackName: element["name"] as? String? ?? "", kind: kindOfMedia, linkForImage: link))
                                }
                            }
                        }
                        let section = MSection(type: kindOfMedia, title: kindOfMedia.prefix(1).uppercased() + kindOfMedia.dropFirst(), results: items)
                        self.sections.append(section)
                    }
                }
            }
        }
        catch {
            print("error")
        }
    }
}


extension ViewController {
    func alert(title: String, message: String, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController {
    
    func hidesKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}



