# KKTableView

对于需要使用~~UITableView~~UITableView或者UICollectionView（版本`0.0.3`已更新到对UICollectionView的支持）来展示一些列表数据的ViewController进行了封装，减轻ViewController的负担。

## Installation

使用CocoaPods

	pod 'KKTableView', :git=>'https://github.com/yiyangest/KKTableView.git'
	

## Usage

### 子类化KKTableViewController

	@inteface ShopListViewController: KKTableViewController
	
	...
	@end
	
然后在`ShopListViewController.m`文件里，实现

	- (void)viewDidLoad {
		[super viewDidLoad];
		
		// 将tableView按照一定的次序加入到self.view中
		[self.view addSubview:self.tableView];
		
		// 设置tableView的布局约束或者frame
		...
	}
	
	// 重写refresh方法，下拉刷新时将会调用此方法
	- (void)refresh {
		[super refresh];
		
		// 发起你的网络请求
	}
	
	// 重写loadMore方法，上拉加载更多时将会调用此方法
	- (void)loadMore {
		[super loadMore];
		
		// 发起你的网络请求
	}
	
	// 重写configureTableView方法，对tableView做定制化
	- (void)configureTableView {
		[super configureTableView];
		
		// 给tableView注册相应的cell
		[self.tableView registerCell....];
		
		// 按照需求定制tableView
		...
	}
	
	- (void)configureDataSource {
		[super configureDataSource];
		
		// 如果有子类化的KKTableViewDataSource，可以在此处对self.dataSource进行初始化
		// self.dataSource = [MultiDataSource new];
		
		// 设置dataSource的cellIdentifier和cell的configureBlock
		self.dataSource.cellIdentifier = @"cell";
		self.dataSource.configureBlock = ^(id cell, id item) {
			[cell configureWithItem:item];
		}
		
		// 如果有tableView含有多种cell，则需要设置多种类型cell的配置条件
		self.dataSource.cellClassConfigureBlock = ^(id item) {
		// 根据item中的属性，返回不同的cellClass
		return [PersonCell class];
		};
		
		// 同时注册各个cell的configureBlock
		[self.dataSource registerConfigureBlock:^(id cell, id item) {
		} forCellClassName:@"PersonCell"];
		
	}
	
KKTableView遵循约定优于配置的原则，cell的identifier与classname保持一致。KKBaseCell的cellReuseIdentifier方法就是按照这个原则实现的。

对于使用UICollectionView的ViewController可以继承KKCollectionViewController, 使用方法基本一样。

### 使用UIViewController+KKDataView的Category

*注意版本`0.0.3`之前的UIViewController+KKTableView的Category已经改名为UIViewController+KKDataView。*

当然，有时候我们的工程里面，已经有一个抽象出来的BaseViewController作为其他ViewController实现的基类，这时候子类化KKTableViewController似乎就不太实用了，不过你仍然可以通过UIViewController+KKDataView这个category来减轻VC的负担，当然也会需要你做一些额外的事情来配合。

首先，你需要遵循KKDataViewControllerDelegate这个协议(当然你可以在extension里面表明遵循这个protocol)：

	@interface CategoryViewController ()<KKDataViewControllerDelegate>
	@end
	
然后在合适的位置(比如在loadView里)调用`kk_loadWithDataViewType`来初始化tableView和datasource的基本配置：

	- (void)loadView {
		[super loadView];
		
		[self kk_loadWithDataViewType:KKDataViewTypeTableView];
	}
`KKDataViewType`是一个枚举，包含tableView和collectionView两种。
之后，你就可以通过self.kk_collectionView或者self.kk_tableView来获取相应的view了。
	
接下来：

	- (void)viewDidLoad {
		// 将tableView按照一定的次序加入到self.view中
		[self.view addSubview:self.kk_tableView];
		
		// 设置tableView的布局约束或者frame
		...
	}
	
	#pragma mark - 实现KKTableViewControllerDelegate
	
	// 下拉刷新时需要处理的业务
	- (void)kk_dataViewWillRefresh {
		// 发起网络请求
	}
	
	// 加载更多时需要处理的业务
	- (void)kk_dataViewWillLoadMore {
		// 发起网络请求
	}
	
	// 配置tableView
	- (void)kk_dataViewDidConfigureDataView {
		// 给tableView注册相应的cell
		[self.kk_tableView registerCell....];
		
		// 按照需求定制tableView
		...

	}
	
	- (void)kk_dataViewDidConfigureDataSource {
		// 如果有子类化的KKTableViewDataSource，可以在此处对self.dataSource进行初始化
		// self.kk_dataSource = [MultiDataSource new];
		
		// 设置dataSource的cellIdentifier和cell的configureBlock
		self.kk_dataSource.cellIdentifier = @"cell";
		self.kk_dataSource.configureBlock = ^(id cell, id item) {
			[cell configureWithItem:item];
		}
		
		// 如果有tableView含有多种cell，则需要设置多种类型cell的配置条件
		self.kk_dataSource.cellClassConfigureBlock = ^(id item) {
		// 根据item中的属性，返回不同的cellClass
		return [PersonCell class];
		};
		
		// 同时注册各个cell的configureBlock
		[self.kk_dataSource registerConfigureBlock:^(id cell, id item) {
		} forCellClassName:@"PersonCell"];
	}
	
## 说明

可以参考[这篇博客](http://yiyangest.sinaapp.com/post/lighter-view-controller-practice)
