import 'package:foap/components/place_picker/place_picker.dart';
import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/chat/drawing_screen.dart';
import 'package:get/get.dart';

class SharingMediaType {
  ThemeIcon icon;
  String text;
  MessageContentType contentType;

  SharingMediaType(
      {required this.icon, required this.text, required this.contentType});
}

class ChatMediaSharingOptionPopup extends StatefulWidget {
  const ChatMediaSharingOptionPopup({Key? key}) : super(key: key);

  @override
  State<ChatMediaSharingOptionPopup> createState() =>
      _ChatMediaSharingOptionPopupState();
}

class _ChatMediaSharingOptionPopupState
    extends State<ChatMediaSharingOptionPopup> {
  final ChatDetailController _chatDetailController = Get.find();

  List<SharingMediaType> mediaTypes = [
    SharingMediaType(
        icon: ThemeIcon.camera,
        text: LocalizationString.photo,
        contentType: MessageContentType.photo),
    SharingMediaType(
        icon: ThemeIcon.files,
        text: LocalizationString.files,
        contentType: MessageContentType.file),
    SharingMediaType(
        icon: ThemeIcon.gif,
        text: LocalizationString.gif,
        contentType: MessageContentType.gif),
    SharingMediaType(
        icon: ThemeIcon.contacts,
        text: LocalizationString.contact,
        contentType: MessageContentType.contact),
    SharingMediaType(
        icon: ThemeIcon.location,
        text: LocalizationString.location,
        contentType: MessageContentType.location),
    SharingMediaType(
        icon: ThemeIcon.mic,
        text: LocalizationString.audio,
        contentType: MessageContentType.audio),
    SharingMediaType(
        icon: ThemeIcon.drawing,
        text: LocalizationString.drawing,
        contentType: MessageContentType.drawing),
    SharingMediaType(
        icon: ThemeIcon.account,
        text: LocalizationString.user,
        contentType: MessageContentType.profile),
    // SharingMediaType(
    //     icon: ThemeIcon.group,
    //     text: LocalizationString.group,
    //     contentType: MessageContentType.group),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: GridView.builder(
                itemCount: mediaTypes.length,
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.8),
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          color: Theme.of(context).cardColor.darken(),
                          child: ThemeIconWidget(
                            mediaTypes[index].icon,
                            size: 18,
                          )).circular,
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        mediaTypes[index].text,
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ).ripple(() {
                    handleAction(mediaTypes[index]);
                  });
                }),
          ).round(20).p16,
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 50,
            width: 50,
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).iconTheme.color,
                size: 25,
              ),
            ),
          ).circular.ripple(() {
            Get.back();
          }),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  handleAction(SharingMediaType mediaType) {
    if (mediaType.contentType == MessageContentType.photo) {
      Get.back();
      openGallery();
    } else if (mediaType.contentType == MessageContentType.gif) {
      Get.back();
      openGiphy();
    } else if (mediaType.contentType == MessageContentType.location) {
      Get.back();
      openLocationPicker();
    } else if (mediaType.contentType == MessageContentType.contact) {
      Get.back();
      openContactList();
    } else if (mediaType.contentType == MessageContentType.audio) {
      Get.back();
      openVoiceRecord();
    } else if (mediaType.contentType == MessageContentType.drawing) {
      Get.back();
      openDrawingBoard();
    } else if (mediaType.contentType == MessageContentType.profile) {
      Get.back();
      openUsersList();
    } else if (mediaType.contentType == MessageContentType.group) {
      Get.back();
      openGroups();
    } else if (mediaType.contentType == MessageContentType.file) {
      openFilePicker();
    }
  }

  openGiphy() async {
    String randomId = 'hsvcewd78djhbejkd';

    GiphyGif? gif = await GiphyGet.getGif(
      context: context,
      //Required
      apiKey: AppConfigConstants.giphyApiKey,
      //Required.
      lang: GiphyLanguage.english,
      //Optional - Language for query.
      randomID: randomId,
      // Optional - An ID/proxy for a specific user.
      tabColor: Colors.teal, // Optional- default accent color.
    );

    if (gif != null) {
      _chatDetailController.sendGifMessage(
          gif: gif.images!.original!.url,
          mode: _chatDetailController.actionMode.value,
          room: _chatDetailController.chatRoom.value!);
    }
  }

  void openVoiceRecord() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => VoiceRecord(
              recordingCallback: (media) {
                _chatDetailController.sendAudioMessage(
                    media: media,
                    mode: _chatDetailController.actionMode.value,
                    context: context,
                    room: _chatDetailController.chatRoom.value!);
              },
            ));
  }

  void openContactList() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => FractionallySizedBox(
              heightFactor: 1,
              child: ContactList(
                selectedContactsHandler: (contacts) {
                  for (Contact contact in contacts) {
                    _chatDetailController.sendContactMessage(
                        contact: contact,
                        mode: _chatDetailController.actionMode.value,
                        context: context,
                        room: _chatDetailController.chatRoom.value!);
                  }
                },
              ),
            ));
  }

  void openLocationPicker() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
            heightFactor: 0.9,
            child: PlacePicker(
              apiKey: AppConfigConstants.googleMapApiKey,
              displayLocation: null,
            ))).then((location) {
      if (location != null) {
        LocationResult result = location as LocationResult;
        LocationModel locationModel = LocationModel(
            latitude: result.latLng!.latitude,
            longitude: result.latLng!.longitude,
            name: result.name!);

        _chatDetailController.sendLocationMessage(
            location: locationModel,
            mode: _chatDetailController.actionMode.value,
            context: context,
            room: _chatDetailController.chatRoom.value!);
      }
    });
  }

  void openDrawingBoard() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        // isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) => const FractionallySizedBox(
            heightFactor: 0.9, child: DrawingScreen()));
  }

  void openGallery() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ChooseMediaForChat(
              selectedMediaCompletetion: (medias) {
                for (Media media in medias) {
                  if (media.mediaType == GalleryMediaType.photo) {
                    _chatDetailController.sendImageMessage(
                        media: media,
                        mode: _chatDetailController.actionMode.value,
                        context: context,
                        room: _chatDetailController.chatRoom.value!);
                    Navigator.of(context).pop();
                  } else {
                    Get.back();
                    _chatDetailController.sendVideoMessage(
                        media: media,
                        mode: _chatDetailController.actionMode.value,
                        context: context,
                        room: _chatDetailController.chatRoom.value!);
                  }
                }
              },
            ));
  }

  void openUsersList() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) =>
            SelectFollowingUserForMessageSending(sendToUserCallback: (user) {
              _chatDetailController.sendUserProfileAsMessage(
                  user: user, room: _chatDetailController.chatRoom.value!);
            }));
  }

  void openGroups() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => VoiceRecord(
              recordingCallback: (media) {
                _chatDetailController.sendAudioMessage(
                    media: media,
                    mode: _chatDetailController.actionMode.value,
                    context: context,
                    room: _chatDetailController.chatRoom.value!);
              },
            ));
  }

  void openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'mp3',
        'mp4',
        'pdf',
        'doc',
        'docx',
        'pptx',
        'ppt',
        'xlsx',
        'xls',
        'txt'
      ],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      Uint8List data = file.readAsBytesSync();
      int sizeInBytes = data.length;

      String fileName = result.files.single.name;

      Media media = Media();
      media.id = randomId();
      media.file = file;
      media.mediaByte = data;
      media.fileSize = sizeInBytes;

      // media.thumbnail = thumbnailData!;
      // media.size = size;
      media.creationTime = DateTime.now();
      media.title = fileName;
      media.mediaType = file.mediaType;

      if (file.mediaType == GalleryMediaType.photo) {
        _chatDetailController.sendImageMessage(
            media: media,
            mode: _chatDetailController.actionMode.value,
            context: context,
            room: _chatDetailController.chatRoom.value!);
      } else if (file.mediaType == GalleryMediaType.video) {
        _chatDetailController.sendVideoMessage(
            media: media,
            mode: _chatDetailController.actionMode.value,
            context: context,
            room: _chatDetailController.chatRoom.value!);
      } else if (file.mediaType == GalleryMediaType.audio) {
        _chatDetailController.sendAudioMessage(
            media: media,
            mode: _chatDetailController.actionMode.value,
            context: context,
            room: _chatDetailController.chatRoom.value!);
      } else {
        _chatDetailController.sendFileMessage(
            media: media,
            mode: _chatDetailController.actionMode.value,
            context: context,
            room: _chatDetailController.chatRoom.value!);
      }
      Get.back();
    } else {
      // User canceled the picker
    }
  }
}
