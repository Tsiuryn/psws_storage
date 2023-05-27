import 'package:json_annotation/json_annotation.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';

part 'sort_bean.g.dart';

@JsonSerializable()
class SortBean {
  @JsonKey(name: 'folderInclude')
  final bool folderInclude;
  @JsonKey(name: 'sortBy')
  final SortByBean sortBy;
  @JsonKey(name: 'sortType')
  final SortTypeBean sortType;

  const SortBean({
    required this.folderInclude,
    required this.sortBy,
    required this.sortType,
  });

  factory SortBean.fromJson(Map<String, dynamic> json) =>
      _$SortBeanFromJson(json);

  Map<String, dynamic> toJson() => _$SortBeanToJson(this);
}

enum SortByBean {
  @JsonValue('NAME')
  name,
  @JsonValue('DATE')
  date,
}

enum SortTypeBean {
  @JsonValue('ASC')
  asc,
  @JsonValue('DESC')
  desc,
}

extension SortExt on Sort {
  SortBean get toBean => SortBean(
        folderInclude: folderInclude,
        sortBy: sortBy == SortBy.name ? SortByBean.name : SortByBean.date,
        sortType:
            sortType == SortType.desc ? SortTypeBean.desc : SortTypeBean.asc,
      );
}

extension SortBeanExt on SortBean? {
  Sort get fromBean {
    final src = this;
    if (src == null) {
      return const Sort.def();
    }

    return Sort(
      folderInclude: src.folderInclude,
      sortBy: src.sortBy == SortByBean.date ? SortBy.date : SortBy.name,
      sortType: src.sortType == SortTypeBean.asc ? SortType.asc : SortType.desc,
    );
  }
}
