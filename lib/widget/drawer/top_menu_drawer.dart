part of gestion_de_table;

class TopMenuDrawer extends StatefulWidget {
  final Function()? onTap;
  const TopMenuDrawer(this.onTap,{Key? key});

  @override
  State<TopMenuDrawer> createState() => _TopMenuDrawerState();
}

class _TopMenuDrawerState extends State<TopMenuDrawer> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 10.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("klitchy restaurant", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.fSize)),
              SizedBox(
                height: 5.v,
              ),
              Text("Restaurant", style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.secondaryTextColor, fontSize: 20.fSize)),
            ],
          )
        ],
      ),
    );
  }
}