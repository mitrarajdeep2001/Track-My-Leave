// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailAppPackageMeta = const VerificationMeta(
    'emailAppPackage',
  );
  @override
  late final GeneratedColumn<String> emailAppPackage = GeneratedColumn<String>(
    'email_app_package',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatsappNumberMeta = const VerificationMeta(
    'whatsappNumber',
  );
  @override
  late final GeneratedColumn<String> whatsappNumber = GeneratedColumn<String>(
    'whatsapp_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatsappNameMeta = const VerificationMeta(
    'whatsappName',
  );
  @override
  late final GeneratedColumn<String> whatsappName = GeneratedColumn<String>(
    'whatsapp_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _llmProviderMeta = const VerificationMeta(
    'llmProvider',
  );
  @override
  late final GeneratedColumn<String> llmProvider = GeneratedColumn<String>(
    'llm_provider',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _llmModelMeta = const VerificationMeta(
    'llmModel',
  );
  @override
  late final GeneratedColumn<String> llmModel = GeneratedColumn<String>(
    'llm_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingDoneMeta = const VerificationMeta(
    'onboardingDone',
  );
  @override
  late final GeneratedColumn<bool> onboardingDone = GeneratedColumn<bool>(
    'onboarding_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _themeColorMeta = const VerificationMeta(
    'themeColor',
  );
  @override
  late final GeneratedColumn<String> themeColor = GeneratedColumn<String>(
    'theme_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('teal'),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _leaveSubjectTplMeta = const VerificationMeta(
    'leaveSubjectTpl',
  );
  @override
  late final GeneratedColumn<String> leaveSubjectTpl = GeneratedColumn<String>(
    'leave_subject_tpl',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leaveBodyTplMeta = const VerificationMeta(
    'leaveBodyTpl',
  );
  @override
  late final GeneratedColumn<String> leaveBodyTpl = GeneratedColumn<String>(
    'leave_body_tpl',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wfhSubjectTplMeta = const VerificationMeta(
    'wfhSubjectTpl',
  );
  @override
  late final GeneratedColumn<String> wfhSubjectTpl = GeneratedColumn<String>(
    'wfh_subject_tpl',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wfhBodyTplMeta = const VerificationMeta(
    'wfhBodyTpl',
  );
  @override
  late final GeneratedColumn<String> wfhBodyTpl = GeneratedColumn<String>(
    'wfh_body_tpl',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastBackupAtMeta = const VerificationMeta(
    'lastBackupAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastBackupAt = GeneratedColumn<DateTime>(
    'last_backup_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userName,
    companyName,
    emailAppPackage,
    whatsappNumber,
    whatsappName,
    llmProvider,
    llmModel,
    onboardingDone,
    themeColor,
    themeMode,
    leaveSubjectTpl,
    leaveBodyTpl,
    wfhSubjectTpl,
    wfhBodyTpl,
    lastBackupAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('email_app_package')) {
      context.handle(
        _emailAppPackageMeta,
        emailAppPackage.isAcceptableOrUnknown(
          data['email_app_package']!,
          _emailAppPackageMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_number')) {
      context.handle(
        _whatsappNumberMeta,
        whatsappNumber.isAcceptableOrUnknown(
          data['whatsapp_number']!,
          _whatsappNumberMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_name')) {
      context.handle(
        _whatsappNameMeta,
        whatsappName.isAcceptableOrUnknown(
          data['whatsapp_name']!,
          _whatsappNameMeta,
        ),
      );
    }
    if (data.containsKey('llm_provider')) {
      context.handle(
        _llmProviderMeta,
        llmProvider.isAcceptableOrUnknown(
          data['llm_provider']!,
          _llmProviderMeta,
        ),
      );
    }
    if (data.containsKey('llm_model')) {
      context.handle(
        _llmModelMeta,
        llmModel.isAcceptableOrUnknown(data['llm_model']!, _llmModelMeta),
      );
    }
    if (data.containsKey('onboarding_done')) {
      context.handle(
        _onboardingDoneMeta,
        onboardingDone.isAcceptableOrUnknown(
          data['onboarding_done']!,
          _onboardingDoneMeta,
        ),
      );
    }
    if (data.containsKey('theme_color')) {
      context.handle(
        _themeColorMeta,
        themeColor.isAcceptableOrUnknown(data['theme_color']!, _themeColorMeta),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('leave_subject_tpl')) {
      context.handle(
        _leaveSubjectTplMeta,
        leaveSubjectTpl.isAcceptableOrUnknown(
          data['leave_subject_tpl']!,
          _leaveSubjectTplMeta,
        ),
      );
    }
    if (data.containsKey('leave_body_tpl')) {
      context.handle(
        _leaveBodyTplMeta,
        leaveBodyTpl.isAcceptableOrUnknown(
          data['leave_body_tpl']!,
          _leaveBodyTplMeta,
        ),
      );
    }
    if (data.containsKey('wfh_subject_tpl')) {
      context.handle(
        _wfhSubjectTplMeta,
        wfhSubjectTpl.isAcceptableOrUnknown(
          data['wfh_subject_tpl']!,
          _wfhSubjectTplMeta,
        ),
      );
    }
    if (data.containsKey('wfh_body_tpl')) {
      context.handle(
        _wfhBodyTplMeta,
        wfhBodyTpl.isAcceptableOrUnknown(
          data['wfh_body_tpl']!,
          _wfhBodyTplMeta,
        ),
      );
    }
    if (data.containsKey('last_backup_at')) {
      context.handle(
        _lastBackupAtMeta,
        lastBackupAt.isAcceptableOrUnknown(
          data['last_backup_at']!,
          _lastBackupAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      emailAppPackage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_app_package'],
      ),
      whatsappNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_number'],
      ),
      whatsappName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_name'],
      ),
      llmProvider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}llm_provider'],
      ),
      llmModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}llm_model'],
      ),
      onboardingDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_done'],
      )!,
      themeColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_color'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      leaveSubjectTpl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leave_subject_tpl'],
      ),
      leaveBodyTpl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leave_body_tpl'],
      ),
      wfhSubjectTpl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wfh_subject_tpl'],
      ),
      wfhBodyTpl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wfh_body_tpl'],
      ),
      lastBackupAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_backup_at'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String userName;
  final String companyName;
  final String? emailAppPackage;
  final String? whatsappNumber;
  final String? whatsappName;
  final String? llmProvider;
  final String? llmModel;
  final bool onboardingDone;
  final String themeColor;
  final String themeMode;
  final String? leaveSubjectTpl;
  final String? leaveBodyTpl;
  final String? wfhSubjectTpl;
  final String? wfhBodyTpl;
  final DateTime? lastBackupAt;
  const AppSetting({
    required this.id,
    required this.userName,
    required this.companyName,
    this.emailAppPackage,
    this.whatsappNumber,
    this.whatsappName,
    this.llmProvider,
    this.llmModel,
    required this.onboardingDone,
    required this.themeColor,
    required this.themeMode,
    this.leaveSubjectTpl,
    this.leaveBodyTpl,
    this.wfhSubjectTpl,
    this.wfhBodyTpl,
    this.lastBackupAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    map['company_name'] = Variable<String>(companyName);
    if (!nullToAbsent || emailAppPackage != null) {
      map['email_app_package'] = Variable<String>(emailAppPackage);
    }
    if (!nullToAbsent || whatsappNumber != null) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber);
    }
    if (!nullToAbsent || whatsappName != null) {
      map['whatsapp_name'] = Variable<String>(whatsappName);
    }
    if (!nullToAbsent || llmProvider != null) {
      map['llm_provider'] = Variable<String>(llmProvider);
    }
    if (!nullToAbsent || llmModel != null) {
      map['llm_model'] = Variable<String>(llmModel);
    }
    map['onboarding_done'] = Variable<bool>(onboardingDone);
    map['theme_color'] = Variable<String>(themeColor);
    map['theme_mode'] = Variable<String>(themeMode);
    if (!nullToAbsent || leaveSubjectTpl != null) {
      map['leave_subject_tpl'] = Variable<String>(leaveSubjectTpl);
    }
    if (!nullToAbsent || leaveBodyTpl != null) {
      map['leave_body_tpl'] = Variable<String>(leaveBodyTpl);
    }
    if (!nullToAbsent || wfhSubjectTpl != null) {
      map['wfh_subject_tpl'] = Variable<String>(wfhSubjectTpl);
    }
    if (!nullToAbsent || wfhBodyTpl != null) {
      map['wfh_body_tpl'] = Variable<String>(wfhBodyTpl);
    }
    if (!nullToAbsent || lastBackupAt != null) {
      map['last_backup_at'] = Variable<DateTime>(lastBackupAt);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      userName: Value(userName),
      companyName: Value(companyName),
      emailAppPackage: emailAppPackage == null && nullToAbsent
          ? const Value.absent()
          : Value(emailAppPackage),
      whatsappNumber: whatsappNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappNumber),
      whatsappName: whatsappName == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappName),
      llmProvider: llmProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(llmProvider),
      llmModel: llmModel == null && nullToAbsent
          ? const Value.absent()
          : Value(llmModel),
      onboardingDone: Value(onboardingDone),
      themeColor: Value(themeColor),
      themeMode: Value(themeMode),
      leaveSubjectTpl: leaveSubjectTpl == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveSubjectTpl),
      leaveBodyTpl: leaveBodyTpl == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveBodyTpl),
      wfhSubjectTpl: wfhSubjectTpl == null && nullToAbsent
          ? const Value.absent()
          : Value(wfhSubjectTpl),
      wfhBodyTpl: wfhBodyTpl == null && nullToAbsent
          ? const Value.absent()
          : Value(wfhBodyTpl),
      lastBackupAt: lastBackupAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBackupAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      companyName: serializer.fromJson<String>(json['companyName']),
      emailAppPackage: serializer.fromJson<String?>(json['emailAppPackage']),
      whatsappNumber: serializer.fromJson<String?>(json['whatsappNumber']),
      whatsappName: serializer.fromJson<String?>(json['whatsappName']),
      llmProvider: serializer.fromJson<String?>(json['llmProvider']),
      llmModel: serializer.fromJson<String?>(json['llmModel']),
      onboardingDone: serializer.fromJson<bool>(json['onboardingDone']),
      themeColor: serializer.fromJson<String>(json['themeColor']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      leaveSubjectTpl: serializer.fromJson<String?>(json['leaveSubjectTpl']),
      leaveBodyTpl: serializer.fromJson<String?>(json['leaveBodyTpl']),
      wfhSubjectTpl: serializer.fromJson<String?>(json['wfhSubjectTpl']),
      wfhBodyTpl: serializer.fromJson<String?>(json['wfhBodyTpl']),
      lastBackupAt: serializer.fromJson<DateTime?>(json['lastBackupAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'companyName': serializer.toJson<String>(companyName),
      'emailAppPackage': serializer.toJson<String?>(emailAppPackage),
      'whatsappNumber': serializer.toJson<String?>(whatsappNumber),
      'whatsappName': serializer.toJson<String?>(whatsappName),
      'llmProvider': serializer.toJson<String?>(llmProvider),
      'llmModel': serializer.toJson<String?>(llmModel),
      'onboardingDone': serializer.toJson<bool>(onboardingDone),
      'themeColor': serializer.toJson<String>(themeColor),
      'themeMode': serializer.toJson<String>(themeMode),
      'leaveSubjectTpl': serializer.toJson<String?>(leaveSubjectTpl),
      'leaveBodyTpl': serializer.toJson<String?>(leaveBodyTpl),
      'wfhSubjectTpl': serializer.toJson<String?>(wfhSubjectTpl),
      'wfhBodyTpl': serializer.toJson<String?>(wfhBodyTpl),
      'lastBackupAt': serializer.toJson<DateTime?>(lastBackupAt),
    };
  }

  AppSetting copyWith({
    int? id,
    String? userName,
    String? companyName,
    Value<String?> emailAppPackage = const Value.absent(),
    Value<String?> whatsappNumber = const Value.absent(),
    Value<String?> whatsappName = const Value.absent(),
    Value<String?> llmProvider = const Value.absent(),
    Value<String?> llmModel = const Value.absent(),
    bool? onboardingDone,
    String? themeColor,
    String? themeMode,
    Value<String?> leaveSubjectTpl = const Value.absent(),
    Value<String?> leaveBodyTpl = const Value.absent(),
    Value<String?> wfhSubjectTpl = const Value.absent(),
    Value<String?> wfhBodyTpl = const Value.absent(),
    Value<DateTime?> lastBackupAt = const Value.absent(),
  }) => AppSetting(
    id: id ?? this.id,
    userName: userName ?? this.userName,
    companyName: companyName ?? this.companyName,
    emailAppPackage: emailAppPackage.present
        ? emailAppPackage.value
        : this.emailAppPackage,
    whatsappNumber: whatsappNumber.present
        ? whatsappNumber.value
        : this.whatsappNumber,
    whatsappName: whatsappName.present ? whatsappName.value : this.whatsappName,
    llmProvider: llmProvider.present ? llmProvider.value : this.llmProvider,
    llmModel: llmModel.present ? llmModel.value : this.llmModel,
    onboardingDone: onboardingDone ?? this.onboardingDone,
    themeColor: themeColor ?? this.themeColor,
    themeMode: themeMode ?? this.themeMode,
    leaveSubjectTpl: leaveSubjectTpl.present
        ? leaveSubjectTpl.value
        : this.leaveSubjectTpl,
    leaveBodyTpl: leaveBodyTpl.present ? leaveBodyTpl.value : this.leaveBodyTpl,
    wfhSubjectTpl: wfhSubjectTpl.present
        ? wfhSubjectTpl.value
        : this.wfhSubjectTpl,
    wfhBodyTpl: wfhBodyTpl.present ? wfhBodyTpl.value : this.wfhBodyTpl,
    lastBackupAt: lastBackupAt.present ? lastBackupAt.value : this.lastBackupAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      userName: data.userName.present ? data.userName.value : this.userName,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      emailAppPackage: data.emailAppPackage.present
          ? data.emailAppPackage.value
          : this.emailAppPackage,
      whatsappNumber: data.whatsappNumber.present
          ? data.whatsappNumber.value
          : this.whatsappNumber,
      whatsappName: data.whatsappName.present
          ? data.whatsappName.value
          : this.whatsappName,
      llmProvider: data.llmProvider.present
          ? data.llmProvider.value
          : this.llmProvider,
      llmModel: data.llmModel.present ? data.llmModel.value : this.llmModel,
      onboardingDone: data.onboardingDone.present
          ? data.onboardingDone.value
          : this.onboardingDone,
      themeColor: data.themeColor.present
          ? data.themeColor.value
          : this.themeColor,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      leaveSubjectTpl: data.leaveSubjectTpl.present
          ? data.leaveSubjectTpl.value
          : this.leaveSubjectTpl,
      leaveBodyTpl: data.leaveBodyTpl.present
          ? data.leaveBodyTpl.value
          : this.leaveBodyTpl,
      wfhSubjectTpl: data.wfhSubjectTpl.present
          ? data.wfhSubjectTpl.value
          : this.wfhSubjectTpl,
      wfhBodyTpl: data.wfhBodyTpl.present
          ? data.wfhBodyTpl.value
          : this.wfhBodyTpl,
      lastBackupAt: data.lastBackupAt.present
          ? data.lastBackupAt.value
          : this.lastBackupAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('companyName: $companyName, ')
          ..write('emailAppPackage: $emailAppPackage, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('whatsappName: $whatsappName, ')
          ..write('llmProvider: $llmProvider, ')
          ..write('llmModel: $llmModel, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('themeColor: $themeColor, ')
          ..write('themeMode: $themeMode, ')
          ..write('leaveSubjectTpl: $leaveSubjectTpl, ')
          ..write('leaveBodyTpl: $leaveBodyTpl, ')
          ..write('wfhSubjectTpl: $wfhSubjectTpl, ')
          ..write('wfhBodyTpl: $wfhBodyTpl, ')
          ..write('lastBackupAt: $lastBackupAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userName,
    companyName,
    emailAppPackage,
    whatsappNumber,
    whatsappName,
    llmProvider,
    llmModel,
    onboardingDone,
    themeColor,
    themeMode,
    leaveSubjectTpl,
    leaveBodyTpl,
    wfhSubjectTpl,
    wfhBodyTpl,
    lastBackupAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.companyName == this.companyName &&
          other.emailAppPackage == this.emailAppPackage &&
          other.whatsappNumber == this.whatsappNumber &&
          other.whatsappName == this.whatsappName &&
          other.llmProvider == this.llmProvider &&
          other.llmModel == this.llmModel &&
          other.onboardingDone == this.onboardingDone &&
          other.themeColor == this.themeColor &&
          other.themeMode == this.themeMode &&
          other.leaveSubjectTpl == this.leaveSubjectTpl &&
          other.leaveBodyTpl == this.leaveBodyTpl &&
          other.wfhSubjectTpl == this.wfhSubjectTpl &&
          other.wfhBodyTpl == this.wfhBodyTpl &&
          other.lastBackupAt == this.lastBackupAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> companyName;
  final Value<String?> emailAppPackage;
  final Value<String?> whatsappNumber;
  final Value<String?> whatsappName;
  final Value<String?> llmProvider;
  final Value<String?> llmModel;
  final Value<bool> onboardingDone;
  final Value<String> themeColor;
  final Value<String> themeMode;
  final Value<String?> leaveSubjectTpl;
  final Value<String?> leaveBodyTpl;
  final Value<String?> wfhSubjectTpl;
  final Value<String?> wfhBodyTpl;
  final Value<DateTime?> lastBackupAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.companyName = const Value.absent(),
    this.emailAppPackage = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.whatsappName = const Value.absent(),
    this.llmProvider = const Value.absent(),
    this.llmModel = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.leaveSubjectTpl = const Value.absent(),
    this.leaveBodyTpl = const Value.absent(),
    this.wfhSubjectTpl = const Value.absent(),
    this.wfhBodyTpl = const Value.absent(),
    this.lastBackupAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.companyName = const Value.absent(),
    this.emailAppPackage = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.whatsappName = const Value.absent(),
    this.llmProvider = const Value.absent(),
    this.llmModel = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.leaveSubjectTpl = const Value.absent(),
    this.leaveBodyTpl = const Value.absent(),
    this.wfhSubjectTpl = const Value.absent(),
    this.wfhBodyTpl = const Value.absent(),
    this.lastBackupAt = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? companyName,
    Expression<String>? emailAppPackage,
    Expression<String>? whatsappNumber,
    Expression<String>? whatsappName,
    Expression<String>? llmProvider,
    Expression<String>? llmModel,
    Expression<bool>? onboardingDone,
    Expression<String>? themeColor,
    Expression<String>? themeMode,
    Expression<String>? leaveSubjectTpl,
    Expression<String>? leaveBodyTpl,
    Expression<String>? wfhSubjectTpl,
    Expression<String>? wfhBodyTpl,
    Expression<DateTime>? lastBackupAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (companyName != null) 'company_name': companyName,
      if (emailAppPackage != null) 'email_app_package': emailAppPackage,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (whatsappName != null) 'whatsapp_name': whatsappName,
      if (llmProvider != null) 'llm_provider': llmProvider,
      if (llmModel != null) 'llm_model': llmModel,
      if (onboardingDone != null) 'onboarding_done': onboardingDone,
      if (themeColor != null) 'theme_color': themeColor,
      if (themeMode != null) 'theme_mode': themeMode,
      if (leaveSubjectTpl != null) 'leave_subject_tpl': leaveSubjectTpl,
      if (leaveBodyTpl != null) 'leave_body_tpl': leaveBodyTpl,
      if (wfhSubjectTpl != null) 'wfh_subject_tpl': wfhSubjectTpl,
      if (wfhBodyTpl != null) 'wfh_body_tpl': wfhBodyTpl,
      if (lastBackupAt != null) 'last_backup_at': lastBackupAt,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? userName,
    Value<String>? companyName,
    Value<String?>? emailAppPackage,
    Value<String?>? whatsappNumber,
    Value<String?>? whatsappName,
    Value<String?>? llmProvider,
    Value<String?>? llmModel,
    Value<bool>? onboardingDone,
    Value<String>? themeColor,
    Value<String>? themeMode,
    Value<String?>? leaveSubjectTpl,
    Value<String?>? leaveBodyTpl,
    Value<String?>? wfhSubjectTpl,
    Value<String?>? wfhBodyTpl,
    Value<DateTime?>? lastBackupAt,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      companyName: companyName ?? this.companyName,
      emailAppPackage: emailAppPackage ?? this.emailAppPackage,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      whatsappName: whatsappName ?? this.whatsappName,
      llmProvider: llmProvider ?? this.llmProvider,
      llmModel: llmModel ?? this.llmModel,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      themeColor: themeColor ?? this.themeColor,
      themeMode: themeMode ?? this.themeMode,
      leaveSubjectTpl: leaveSubjectTpl ?? this.leaveSubjectTpl,
      leaveBodyTpl: leaveBodyTpl ?? this.leaveBodyTpl,
      wfhSubjectTpl: wfhSubjectTpl ?? this.wfhSubjectTpl,
      wfhBodyTpl: wfhBodyTpl ?? this.wfhBodyTpl,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (emailAppPackage.present) {
      map['email_app_package'] = Variable<String>(emailAppPackage.value);
    }
    if (whatsappNumber.present) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber.value);
    }
    if (whatsappName.present) {
      map['whatsapp_name'] = Variable<String>(whatsappName.value);
    }
    if (llmProvider.present) {
      map['llm_provider'] = Variable<String>(llmProvider.value);
    }
    if (llmModel.present) {
      map['llm_model'] = Variable<String>(llmModel.value);
    }
    if (onboardingDone.present) {
      map['onboarding_done'] = Variable<bool>(onboardingDone.value);
    }
    if (themeColor.present) {
      map['theme_color'] = Variable<String>(themeColor.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (leaveSubjectTpl.present) {
      map['leave_subject_tpl'] = Variable<String>(leaveSubjectTpl.value);
    }
    if (leaveBodyTpl.present) {
      map['leave_body_tpl'] = Variable<String>(leaveBodyTpl.value);
    }
    if (wfhSubjectTpl.present) {
      map['wfh_subject_tpl'] = Variable<String>(wfhSubjectTpl.value);
    }
    if (wfhBodyTpl.present) {
      map['wfh_body_tpl'] = Variable<String>(wfhBodyTpl.value);
    }
    if (lastBackupAt.present) {
      map['last_backup_at'] = Variable<DateTime>(lastBackupAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('companyName: $companyName, ')
          ..write('emailAppPackage: $emailAppPackage, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('whatsappName: $whatsappName, ')
          ..write('llmProvider: $llmProvider, ')
          ..write('llmModel: $llmModel, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('themeColor: $themeColor, ')
          ..write('themeMode: $themeMode, ')
          ..write('leaveSubjectTpl: $leaveSubjectTpl, ')
          ..write('leaveBodyTpl: $leaveBodyTpl, ')
          ..write('wfhSubjectTpl: $wfhSubjectTpl, ')
          ..write('wfhBodyTpl: $wfhBodyTpl, ')
          ..write('lastBackupAt: $lastBackupAt')
          ..write(')'))
        .toString();
  }
}

class $RecipientsTable extends Recipients
    with TableInfo<$RecipientsTable, Recipient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('to'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, email, kind];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {email},
  ];
  @override
  Recipient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
    );
  }

  @override
  $RecipientsTable createAlias(String alias) {
    return $RecipientsTable(attachedDatabase, alias);
  }
}

class Recipient extends DataClass implements Insertable<Recipient> {
  final int id;
  final String? name;
  final String email;
  final String kind;
  const Recipient({
    required this.id,
    this.name,
    required this.email,
    required this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['email'] = Variable<String>(email);
    map['kind'] = Variable<String>(kind);
    return map;
  }

  RecipientsCompanion toCompanion(bool nullToAbsent) {
    return RecipientsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email: Value(email),
      kind: Value(kind),
    );
  }

  factory Recipient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      kind: serializer.fromJson<String>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String>(email),
      'kind': serializer.toJson<String>(kind),
    };
  }

  Recipient copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    String? email,
    String? kind,
  }) => Recipient(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    email: email ?? this.email,
    kind: kind ?? this.kind,
  );
  Recipient copyWithCompanion(RecipientsCompanion data) {
    return Recipient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, kind);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipient &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.kind == this.kind);
}

class RecipientsCompanion extends UpdateCompanion<Recipient> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String> email;
  final Value<String> kind;
  const RecipientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.kind = const Value.absent(),
  });
  RecipientsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required String email,
    this.kind = const Value.absent(),
  }) : email = Value(email);
  static Insertable<Recipient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? kind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (kind != null) 'kind': kind,
    });
  }

  RecipientsCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String>? email,
    Value<String>? kind,
  }) {
    return RecipientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      kind: kind ?? this.kind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }
}

class $LeaveTypesTable extends LeaveTypes
    with TableInfo<$LeaveTypesTable, LeaveType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysPerYearMeta = const VerificationMeta(
    'daysPerYear',
  );
  @override
  late final GeneratedColumn<double> daysPerYear = GeneratedColumn<double>(
    'days_per_year',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carryForwardMeta = const VerificationMeta(
    'carryForward',
  );
  @override
  late final GeneratedColumn<bool> carryForward = GeneratedColumn<bool>(
    'carry_forward',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("carry_forward" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _maxCarryForwardDaysMeta =
      const VerificationMeta('maxCarryForwardDays');
  @override
  late final GeneratedColumn<double> maxCarryForwardDays =
      GeneratedColumn<double>(
        'max_carry_forward_days',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    daysPerYear,
    carryForward,
    maxCarryForwardDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('days_per_year')) {
      context.handle(
        _daysPerYearMeta,
        daysPerYear.isAcceptableOrUnknown(
          data['days_per_year']!,
          _daysPerYearMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_daysPerYearMeta);
    }
    if (data.containsKey('carry_forward')) {
      context.handle(
        _carryForwardMeta,
        carryForward.isAcceptableOrUnknown(
          data['carry_forward']!,
          _carryForwardMeta,
        ),
      );
    }
    if (data.containsKey('max_carry_forward_days')) {
      context.handle(
        _maxCarryForwardDaysMeta,
        maxCarryForwardDays.isAcceptableOrUnknown(
          data['max_carry_forward_days']!,
          _maxCarryForwardDaysMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      daysPerYear: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}days_per_year'],
      )!,
      carryForward: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}carry_forward'],
      )!,
      maxCarryForwardDays: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_carry_forward_days'],
      ),
    );
  }

  @override
  $LeaveTypesTable createAlias(String alias) {
    return $LeaveTypesTable(attachedDatabase, alias);
  }
}

class LeaveType extends DataClass implements Insertable<LeaveType> {
  final int id;
  final String name;
  final double daysPerYear;
  final bool carryForward;
  final double? maxCarryForwardDays;
  const LeaveType({
    required this.id,
    required this.name,
    required this.daysPerYear,
    required this.carryForward,
    this.maxCarryForwardDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['days_per_year'] = Variable<double>(daysPerYear);
    map['carry_forward'] = Variable<bool>(carryForward);
    if (!nullToAbsent || maxCarryForwardDays != null) {
      map['max_carry_forward_days'] = Variable<double>(maxCarryForwardDays);
    }
    return map;
  }

  LeaveTypesCompanion toCompanion(bool nullToAbsent) {
    return LeaveTypesCompanion(
      id: Value(id),
      name: Value(name),
      daysPerYear: Value(daysPerYear),
      carryForward: Value(carryForward),
      maxCarryForwardDays: maxCarryForwardDays == null && nullToAbsent
          ? const Value.absent()
          : Value(maxCarryForwardDays),
    );
  }

  factory LeaveType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      daysPerYear: serializer.fromJson<double>(json['daysPerYear']),
      carryForward: serializer.fromJson<bool>(json['carryForward']),
      maxCarryForwardDays: serializer.fromJson<double?>(
        json['maxCarryForwardDays'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'daysPerYear': serializer.toJson<double>(daysPerYear),
      'carryForward': serializer.toJson<bool>(carryForward),
      'maxCarryForwardDays': serializer.toJson<double?>(maxCarryForwardDays),
    };
  }

  LeaveType copyWith({
    int? id,
    String? name,
    double? daysPerYear,
    bool? carryForward,
    Value<double?> maxCarryForwardDays = const Value.absent(),
  }) => LeaveType(
    id: id ?? this.id,
    name: name ?? this.name,
    daysPerYear: daysPerYear ?? this.daysPerYear,
    carryForward: carryForward ?? this.carryForward,
    maxCarryForwardDays: maxCarryForwardDays.present
        ? maxCarryForwardDays.value
        : this.maxCarryForwardDays,
  );
  LeaveType copyWithCompanion(LeaveTypesCompanion data) {
    return LeaveType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      daysPerYear: data.daysPerYear.present
          ? data.daysPerYear.value
          : this.daysPerYear,
      carryForward: data.carryForward.present
          ? data.carryForward.value
          : this.carryForward,
      maxCarryForwardDays: data.maxCarryForwardDays.present
          ? data.maxCarryForwardDays.value
          : this.maxCarryForwardDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('daysPerYear: $daysPerYear, ')
          ..write('carryForward: $carryForward, ')
          ..write('maxCarryForwardDays: $maxCarryForwardDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, daysPerYear, carryForward, maxCarryForwardDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveType &&
          other.id == this.id &&
          other.name == this.name &&
          other.daysPerYear == this.daysPerYear &&
          other.carryForward == this.carryForward &&
          other.maxCarryForwardDays == this.maxCarryForwardDays);
}

class LeaveTypesCompanion extends UpdateCompanion<LeaveType> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> daysPerYear;
  final Value<bool> carryForward;
  final Value<double?> maxCarryForwardDays;
  const LeaveTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.daysPerYear = const Value.absent(),
    this.carryForward = const Value.absent(),
    this.maxCarryForwardDays = const Value.absent(),
  });
  LeaveTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double daysPerYear,
    this.carryForward = const Value.absent(),
    this.maxCarryForwardDays = const Value.absent(),
  }) : name = Value(name),
       daysPerYear = Value(daysPerYear);
  static Insertable<LeaveType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? daysPerYear,
    Expression<bool>? carryForward,
    Expression<double>? maxCarryForwardDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (daysPerYear != null) 'days_per_year': daysPerYear,
      if (carryForward != null) 'carry_forward': carryForward,
      if (maxCarryForwardDays != null)
        'max_carry_forward_days': maxCarryForwardDays,
    });
  }

  LeaveTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? daysPerYear,
    Value<bool>? carryForward,
    Value<double?>? maxCarryForwardDays,
  }) {
    return LeaveTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      daysPerYear: daysPerYear ?? this.daysPerYear,
      carryForward: carryForward ?? this.carryForward,
      maxCarryForwardDays: maxCarryForwardDays ?? this.maxCarryForwardDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (daysPerYear.present) {
      map['days_per_year'] = Variable<double>(daysPerYear.value);
    }
    if (carryForward.present) {
      map['carry_forward'] = Variable<bool>(carryForward.value);
    }
    if (maxCarryForwardDays.present) {
      map['max_carry_forward_days'] = Variable<double>(
        maxCarryForwardDays.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('daysPerYear: $daysPerYear, ')
          ..write('carryForward: $carryForward, ')
          ..write('maxCarryForwardDays: $maxCarryForwardDays')
          ..write(')'))
        .toString();
  }
}

class $HolidaysTable extends Holidays with TableInfo<$HolidaysTable, Holiday> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HolidaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionalMeta = const VerificationMeta(
    'optional',
  );
  @override
  late final GeneratedColumn<bool> optional = GeneratedColumn<bool>(
    'optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, date, optional];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holidays';
  @override
  VerificationContext validateIntegrity(
    Insertable<Holiday> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('optional')) {
      context.handle(
        _optionalMeta,
        optional.isAcceptableOrUnknown(data['optional']!, _optionalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date, name},
  ];
  @override
  Holiday map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Holiday(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      optional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}optional'],
      )!,
    );
  }

  @override
  $HolidaysTable createAlias(String alias) {
    return $HolidaysTable(attachedDatabase, alias);
  }
}

class Holiday extends DataClass implements Insertable<Holiday> {
  final int id;
  final String name;
  final DateTime date;
  final bool optional;
  const Holiday({
    required this.id,
    required this.name,
    required this.date,
    required this.optional,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<DateTime>(date);
    map['optional'] = Variable<bool>(optional);
    return map;
  }

  HolidaysCompanion toCompanion(bool nullToAbsent) {
    return HolidaysCompanion(
      id: Value(id),
      name: Value(name),
      date: Value(date),
      optional: Value(optional),
    );
  }

  factory Holiday.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Holiday(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      optional: serializer.fromJson<bool>(json['optional']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime>(date),
      'optional': serializer.toJson<bool>(optional),
    };
  }

  Holiday copyWith({int? id, String? name, DateTime? date, bool? optional}) =>
      Holiday(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        optional: optional ?? this.optional,
      );
  Holiday copyWithCompanion(HolidaysCompanion data) {
    return Holiday(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      optional: data.optional.present ? data.optional.value : this.optional,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Holiday(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('optional: $optional')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, date, optional);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Holiday &&
          other.id == this.id &&
          other.name == this.name &&
          other.date == this.date &&
          other.optional == this.optional);
}

class HolidaysCompanion extends UpdateCompanion<Holiday> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> date;
  final Value<bool> optional;
  const HolidaysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.optional = const Value.absent(),
  });
  HolidaysCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime date,
    this.optional = const Value.absent(),
  }) : name = Value(name),
       date = Value(date);
  static Insertable<Holiday> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? date,
    Expression<bool>? optional,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (optional != null) 'optional': optional,
    });
  }

  HolidaysCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? date,
    Value<bool>? optional,
  }) {
    return HolidaysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      optional: optional ?? this.optional,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (optional.present) {
      map['optional'] = Variable<bool>(optional.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HolidaysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('optional: $optional')
          ..write(')'))
        .toString();
  }
}

class $WfhAllowancesTable extends WfhAllowances
    with TableInfo<$WfhAllowancesTable, WfhAllowance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WfhAllowancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _daysAllowedMeta = const VerificationMeta(
    'daysAllowed',
  );
  @override
  late final GeneratedColumn<int> daysAllowed = GeneratedColumn<int>(
    'days_allowed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [month, daysAllowed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wfh_allowances';
  @override
  VerificationContext validateIntegrity(
    Insertable<WfhAllowance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    }
    if (data.containsKey('days_allowed')) {
      context.handle(
        _daysAllowedMeta,
        daysAllowed.isAcceptableOrUnknown(
          data['days_allowed']!,
          _daysAllowedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_daysAllowedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {month};
  @override
  WfhAllowance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WfhAllowance(
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      daysAllowed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_allowed'],
      )!,
    );
  }

  @override
  $WfhAllowancesTable createAlias(String alias) {
    return $WfhAllowancesTable(attachedDatabase, alias);
  }
}

class WfhAllowance extends DataClass implements Insertable<WfhAllowance> {
  final int month;
  final int daysAllowed;
  const WfhAllowance({required this.month, required this.daysAllowed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['month'] = Variable<int>(month);
    map['days_allowed'] = Variable<int>(daysAllowed);
    return map;
  }

  WfhAllowancesCompanion toCompanion(bool nullToAbsent) {
    return WfhAllowancesCompanion(
      month: Value(month),
      daysAllowed: Value(daysAllowed),
    );
  }

  factory WfhAllowance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WfhAllowance(
      month: serializer.fromJson<int>(json['month']),
      daysAllowed: serializer.fromJson<int>(json['daysAllowed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'month': serializer.toJson<int>(month),
      'daysAllowed': serializer.toJson<int>(daysAllowed),
    };
  }

  WfhAllowance copyWith({int? month, int? daysAllowed}) => WfhAllowance(
    month: month ?? this.month,
    daysAllowed: daysAllowed ?? this.daysAllowed,
  );
  WfhAllowance copyWithCompanion(WfhAllowancesCompanion data) {
    return WfhAllowance(
      month: data.month.present ? data.month.value : this.month,
      daysAllowed: data.daysAllowed.present
          ? data.daysAllowed.value
          : this.daysAllowed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WfhAllowance(')
          ..write('month: $month, ')
          ..write('daysAllowed: $daysAllowed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(month, daysAllowed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WfhAllowance &&
          other.month == this.month &&
          other.daysAllowed == this.daysAllowed);
}

class WfhAllowancesCompanion extends UpdateCompanion<WfhAllowance> {
  final Value<int> month;
  final Value<int> daysAllowed;
  const WfhAllowancesCompanion({
    this.month = const Value.absent(),
    this.daysAllowed = const Value.absent(),
  });
  WfhAllowancesCompanion.insert({
    this.month = const Value.absent(),
    required int daysAllowed,
  }) : daysAllowed = Value(daysAllowed);
  static Insertable<WfhAllowance> custom({
    Expression<int>? month,
    Expression<int>? daysAllowed,
  }) {
    return RawValuesInsertable({
      if (month != null) 'month': month,
      if (daysAllowed != null) 'days_allowed': daysAllowed,
    });
  }

  WfhAllowancesCompanion copyWith({
    Value<int>? month,
    Value<int>? daysAllowed,
  }) {
    return WfhAllowancesCompanion(
      month: month ?? this.month,
      daysAllowed: daysAllowed ?? this.daysAllowed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (daysAllowed.present) {
      map['days_allowed'] = Variable<int>(daysAllowed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WfhAllowancesCompanion(')
          ..write('month: $month, ')
          ..write('daysAllowed: $daysAllowed')
          ..write(')'))
        .toString();
  }
}

class $LeaveRequestsTable extends LeaveRequests
    with TableInfo<$LeaveRequestsTable, LeaveRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('leave'),
  );
  static const VerificationMeta _leaveTypeIdMeta = const VerificationMeta(
    'leaveTypeId',
  );
  @override
  late final GeneratedColumn<int> leaveTypeId = GeneratedColumn<int>(
    'leave_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES leave_types (id)',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<double> days = GeneratedColumn<double>(
    'days',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
    'applied_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    leaveTypeId,
    startDate,
    endDate,
    days,
    reason,
    status,
    createdAt,
    appliedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('leave_type_id')) {
      context.handle(
        _leaveTypeIdMeta,
        leaveTypeId.isAcceptableOrUnknown(
          data['leave_type_id']!,
          _leaveTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('days')) {
      context.handle(
        _daysMeta,
        days.isAcceptableOrUnknown(data['days']!, _daysMeta),
      );
    } else if (isInserting) {
      context.missing(_daysMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      leaveTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leave_type_id'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      days: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}days'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      appliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}applied_at'],
      ),
    );
  }

  @override
  $LeaveRequestsTable createAlias(String alias) {
    return $LeaveRequestsTable(attachedDatabase, alias);
  }
}

class LeaveRequest extends DataClass implements Insertable<LeaveRequest> {
  final int id;
  final String category;
  final int? leaveTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final double days;
  final String? reason;
  final String status;
  final DateTime createdAt;
  final DateTime? appliedAt;
  const LeaveRequest({
    required this.id,
    required this.category,
    this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.days,
    this.reason,
    required this.status,
    required this.createdAt,
    this.appliedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || leaveTypeId != null) {
      map['leave_type_id'] = Variable<int>(leaveTypeId);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['days'] = Variable<double>(days);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || appliedAt != null) {
      map['applied_at'] = Variable<DateTime>(appliedAt);
    }
    return map;
  }

  LeaveRequestsCompanion toCompanion(bool nullToAbsent) {
    return LeaveRequestsCompanion(
      id: Value(id),
      category: Value(category),
      leaveTypeId: leaveTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveTypeId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      days: Value(days),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      status: Value(status),
      createdAt: Value(createdAt),
      appliedAt: appliedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(appliedAt),
    );
  }

  factory LeaveRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveRequest(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      leaveTypeId: serializer.fromJson<int?>(json['leaveTypeId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      days: serializer.fromJson<double>(json['days']),
      reason: serializer.fromJson<String?>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      appliedAt: serializer.fromJson<DateTime?>(json['appliedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'leaveTypeId': serializer.toJson<int?>(leaveTypeId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'days': serializer.toJson<double>(days),
      'reason': serializer.toJson<String?>(reason),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'appliedAt': serializer.toJson<DateTime?>(appliedAt),
    };
  }

  LeaveRequest copyWith({
    int? id,
    String? category,
    Value<int?> leaveTypeId = const Value.absent(),
    DateTime? startDate,
    DateTime? endDate,
    double? days,
    Value<String?> reason = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<DateTime?> appliedAt = const Value.absent(),
  }) => LeaveRequest(
    id: id ?? this.id,
    category: category ?? this.category,
    leaveTypeId: leaveTypeId.present ? leaveTypeId.value : this.leaveTypeId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    days: days ?? this.days,
    reason: reason.present ? reason.value : this.reason,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    appliedAt: appliedAt.present ? appliedAt.value : this.appliedAt,
  );
  LeaveRequest copyWithCompanion(LeaveRequestsCompanion data) {
    return LeaveRequest(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      leaveTypeId: data.leaveTypeId.present
          ? data.leaveTypeId.value
          : this.leaveTypeId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      days: data.days.present ? data.days.value : this.days,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRequest(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('leaveTypeId: $leaveTypeId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('days: $days, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('appliedAt: $appliedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    leaveTypeId,
    startDate,
    endDate,
    days,
    reason,
    status,
    createdAt,
    appliedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveRequest &&
          other.id == this.id &&
          other.category == this.category &&
          other.leaveTypeId == this.leaveTypeId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.days == this.days &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.appliedAt == this.appliedAt);
}

class LeaveRequestsCompanion extends UpdateCompanion<LeaveRequest> {
  final Value<int> id;
  final Value<String> category;
  final Value<int?> leaveTypeId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<double> days;
  final Value<String?> reason;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> appliedAt;
  const LeaveRequestsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.leaveTypeId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.days = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.appliedAt = const Value.absent(),
  });
  LeaveRequestsCompanion.insert({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.leaveTypeId = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required double days,
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.appliedAt = const Value.absent(),
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       days = Value(days);
  static Insertable<LeaveRequest> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<int>? leaveTypeId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<double>? days,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? appliedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (leaveTypeId != null) 'leave_type_id': leaveTypeId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (days != null) 'days': days,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (appliedAt != null) 'applied_at': appliedAt,
    });
  }

  LeaveRequestsCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<int?>? leaveTypeId,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<double>? days,
    Value<String?>? reason,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? appliedAt,
  }) {
    return LeaveRequestsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      leaveTypeId: leaveTypeId ?? this.leaveTypeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (leaveTypeId.present) {
      map['leave_type_id'] = Variable<int>(leaveTypeId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (days.present) {
      map['days'] = Variable<double>(days.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRequestsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('leaveTypeId: $leaveTypeId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('days: $days, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('appliedAt: $appliedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $RecipientsTable recipients = $RecipientsTable(this);
  late final $LeaveTypesTable leaveTypes = $LeaveTypesTable(this);
  late final $HolidaysTable holidays = $HolidaysTable(this);
  late final $WfhAllowancesTable wfhAllowances = $WfhAllowancesTable(this);
  late final $LeaveRequestsTable leaveRequests = $LeaveRequestsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    recipients,
    leaveTypes,
    holidays,
    wfhAllowances,
    leaveRequests,
  ];
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> companyName,
      Value<String?> emailAppPackage,
      Value<String?> whatsappNumber,
      Value<String?> whatsappName,
      Value<String?> llmProvider,
      Value<String?> llmModel,
      Value<bool> onboardingDone,
      Value<String> themeColor,
      Value<String> themeMode,
      Value<String?> leaveSubjectTpl,
      Value<String?> leaveBodyTpl,
      Value<String?> wfhSubjectTpl,
      Value<String?> wfhBodyTpl,
      Value<DateTime?> lastBackupAt,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> companyName,
      Value<String?> emailAppPackage,
      Value<String?> whatsappNumber,
      Value<String?> whatsappName,
      Value<String?> llmProvider,
      Value<String?> llmModel,
      Value<bool> onboardingDone,
      Value<String> themeColor,
      Value<String> themeMode,
      Value<String?> leaveSubjectTpl,
      Value<String?> leaveBodyTpl,
      Value<String?> wfhSubjectTpl,
      Value<String?> wfhBodyTpl,
      Value<DateTime?> lastBackupAt,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailAppPackage => $composableBuilder(
    column: $table.emailAppPackage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappName => $composableBuilder(
    column: $table.whatsappName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get llmProvider => $composableBuilder(
    column: $table.llmProvider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get llmModel => $composableBuilder(
    column: $table.llmModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaveSubjectTpl => $composableBuilder(
    column: $table.leaveSubjectTpl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaveBodyTpl => $composableBuilder(
    column: $table.leaveBodyTpl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wfhSubjectTpl => $composableBuilder(
    column: $table.wfhSubjectTpl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wfhBodyTpl => $composableBuilder(
    column: $table.wfhBodyTpl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailAppPackage => $composableBuilder(
    column: $table.emailAppPackage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappName => $composableBuilder(
    column: $table.whatsappName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get llmProvider => $composableBuilder(
    column: $table.llmProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get llmModel => $composableBuilder(
    column: $table.llmModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaveSubjectTpl => $composableBuilder(
    column: $table.leaveSubjectTpl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaveBodyTpl => $composableBuilder(
    column: $table.leaveBodyTpl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wfhSubjectTpl => $composableBuilder(
    column: $table.wfhSubjectTpl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wfhBodyTpl => $composableBuilder(
    column: $table.wfhBodyTpl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emailAppPackage => $composableBuilder(
    column: $table.emailAppPackage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatsappName => $composableBuilder(
    column: $table.whatsappName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get llmProvider => $composableBuilder(
    column: $table.llmProvider,
    builder: (column) => column,
  );

  GeneratedColumn<String> get llmModel =>
      $composableBuilder(column: $table.llmModel, builder: (column) => column);

  GeneratedColumn<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeColor => $composableBuilder(
    column: $table.themeColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get leaveSubjectTpl => $composableBuilder(
    column: $table.leaveSubjectTpl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get leaveBodyTpl => $composableBuilder(
    column: $table.leaveBodyTpl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wfhSubjectTpl => $composableBuilder(
    column: $table.wfhSubjectTpl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wfhBodyTpl => $composableBuilder(
    column: $table.wfhBodyTpl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String?> emailAppPackage = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<String?> whatsappName = const Value.absent(),
                Value<String?> llmProvider = const Value.absent(),
                Value<String?> llmModel = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                Value<String> themeColor = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> leaveSubjectTpl = const Value.absent(),
                Value<String?> leaveBodyTpl = const Value.absent(),
                Value<String?> wfhSubjectTpl = const Value.absent(),
                Value<String?> wfhBodyTpl = const Value.absent(),
                Value<DateTime?> lastBackupAt = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                userName: userName,
                companyName: companyName,
                emailAppPackage: emailAppPackage,
                whatsappNumber: whatsappNumber,
                whatsappName: whatsappName,
                llmProvider: llmProvider,
                llmModel: llmModel,
                onboardingDone: onboardingDone,
                themeColor: themeColor,
                themeMode: themeMode,
                leaveSubjectTpl: leaveSubjectTpl,
                leaveBodyTpl: leaveBodyTpl,
                wfhSubjectTpl: wfhSubjectTpl,
                wfhBodyTpl: wfhBodyTpl,
                lastBackupAt: lastBackupAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String?> emailAppPackage = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<String?> whatsappName = const Value.absent(),
                Value<String?> llmProvider = const Value.absent(),
                Value<String?> llmModel = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                Value<String> themeColor = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> leaveSubjectTpl = const Value.absent(),
                Value<String?> leaveBodyTpl = const Value.absent(),
                Value<String?> wfhSubjectTpl = const Value.absent(),
                Value<String?> wfhBodyTpl = const Value.absent(),
                Value<DateTime?> lastBackupAt = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                userName: userName,
                companyName: companyName,
                emailAppPackage: emailAppPackage,
                whatsappNumber: whatsappNumber,
                whatsappName: whatsappName,
                llmProvider: llmProvider,
                llmModel: llmModel,
                onboardingDone: onboardingDone,
                themeColor: themeColor,
                themeMode: themeMode,
                leaveSubjectTpl: leaveSubjectTpl,
                leaveBodyTpl: leaveBodyTpl,
                wfhSubjectTpl: wfhSubjectTpl,
                wfhBodyTpl: wfhBodyTpl,
                lastBackupAt: lastBackupAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$RecipientsTableCreateCompanionBuilder = RecipientsCompanion Function({
  Value<int> id,
  Value<String?> name,
  required String email,
  Value<String> kind,
});
typedef $$RecipientsTableUpdateCompanionBuilder = RecipientsCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<String> email,
  Value<String> kind,
});

class $$RecipientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipientsTable> {
  $$RecipientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipientsTable> {
  $$RecipientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipientsTable> {
  $$RecipientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);
}

class $$RecipientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipientsTable,
          Recipient,
          $$RecipientsTableFilterComposer,
          $$RecipientsTableOrderingComposer,
          $$RecipientsTableAnnotationComposer,
          $$RecipientsTableCreateCompanionBuilder,
          $$RecipientsTableUpdateCompanionBuilder,
          (
            Recipient,
            BaseReferences<_$AppDatabase, $RecipientsTable, Recipient>,
          ),
          Recipient,
          PrefetchHooks Function()
        > {
  $$RecipientsTableTableManager(_$AppDatabase db, $RecipientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> kind = const Value.absent(),
              }) => RecipientsCompanion(
                id: id,
                name: name,
                email: email,
                kind: kind,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required String email,
                Value<String> kind = const Value.absent(),
              }) => RecipientsCompanion.insert(
                id: id,
                name: name,
                email: email,
                kind: kind,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipientsTable, Recipient>(table),
                  BaseReferences<_$AppDatabase, $RecipientsTable, Recipient>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipientsTable,
      Recipient,
      $$RecipientsTableFilterComposer,
      $$RecipientsTableOrderingComposer,
      $$RecipientsTableAnnotationComposer,
      $$RecipientsTableCreateCompanionBuilder,
      $$RecipientsTableUpdateCompanionBuilder,
      (Recipient, BaseReferences<_$AppDatabase, $RecipientsTable, Recipient>),
      Recipient,
      PrefetchHooks Function()
    >;
typedef $$LeaveTypesTableCreateCompanionBuilder = LeaveTypesCompanion Function({
  Value<int> id,
  required String name,
  required double daysPerYear,
  Value<bool> carryForward,
  Value<double?> maxCarryForwardDays,
});
typedef $$LeaveTypesTableUpdateCompanionBuilder = LeaveTypesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> daysPerYear,
  Value<bool> carryForward,
  Value<double?> maxCarryForwardDays,
});

final class $$LeaveTypesTableReferences
    extends BaseReferences<_$AppDatabase, $LeaveTypesTable, LeaveType> {
  $$LeaveTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LeaveRequestsTable, List<LeaveRequest>>
  _leaveRequestsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.leaveRequests,
    aliasName: 'leave_types__id__leave_requests__leave_type_id',
  );

  $$LeaveRequestsTableProcessedTableManager get leaveRequestsRefs {
    final manager = $$LeaveRequestsTableTableManager(
      $_db,
      $_db.leaveRequests,
    ).filter((f) => f.leaveTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_leaveRequestsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LeaveTypesTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveTypesTable> {
  $$LeaveTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get daysPerYear => $composableBuilder(
    column: $table.daysPerYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get carryForward => $composableBuilder(
    column: $table.carryForward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxCarryForwardDays => $composableBuilder(
    column: $table.maxCarryForwardDays,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> leaveRequestsRefs(
    Expression<bool> Function($$LeaveRequestsTableFilterComposer f) f,
  ) {
    final $$LeaveRequestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leaveRequests,
      getReferencedColumn: (t) => t.leaveTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveRequestsTableFilterComposer(
            $db: $db,
            $table: $db.leaveRequests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeaveTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveTypesTable> {
  $$LeaveTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get daysPerYear => $composableBuilder(
    column: $table.daysPerYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get carryForward => $composableBuilder(
    column: $table.carryForward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxCarryForwardDays => $composableBuilder(
    column: $table.maxCarryForwardDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveTypesTable> {
  $$LeaveTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get daysPerYear => $composableBuilder(
    column: $table.daysPerYear,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get carryForward => $composableBuilder(
    column: $table.carryForward,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxCarryForwardDays => $composableBuilder(
    column: $table.maxCarryForwardDays,
    builder: (column) => column,
  );

  Expression<T> leaveRequestsRefs<T extends Object>(
    Expression<T> Function($$LeaveRequestsTableAnnotationComposer a) f,
  ) {
    final $$LeaveRequestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leaveRequests,
      getReferencedColumn: (t) => t.leaveTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveRequestsTableAnnotationComposer(
            $db: $db,
            $table: $db.leaveRequests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeaveTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveTypesTable,
          LeaveType,
          $$LeaveTypesTableFilterComposer,
          $$LeaveTypesTableOrderingComposer,
          $$LeaveTypesTableAnnotationComposer,
          $$LeaveTypesTableCreateCompanionBuilder,
          $$LeaveTypesTableUpdateCompanionBuilder,
          (LeaveType, $$LeaveTypesTableReferences),
          LeaveType,
          PrefetchHooks Function({bool leaveRequestsRefs})
        > {
  $$LeaveTypesTableTableManager(_$AppDatabase db, $LeaveTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> daysPerYear = const Value.absent(),
                Value<bool> carryForward = const Value.absent(),
                Value<double?> maxCarryForwardDays = const Value.absent(),
              }) => LeaveTypesCompanion(
                id: id,
                name: name,
                daysPerYear: daysPerYear,
                carryForward: carryForward,
                maxCarryForwardDays: maxCarryForwardDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double daysPerYear,
                Value<bool> carryForward = const Value.absent(),
                Value<double?> maxCarryForwardDays = const Value.absent(),
              }) => LeaveTypesCompanion.insert(
                id: id,
                name: name,
                daysPerYear: daysPerYear,
                carryForward: carryForward,
                maxCarryForwardDays: maxCarryForwardDays,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeaveTypesTable, LeaveType>(table),
                  $$LeaveTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({leaveRequestsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (leaveRequestsRefs) db.leaveRequests,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (leaveRequestsRefs)
                    await $_getPrefetchedDataByColumns<
                      LeaveType,
                      $LeaveTypesTable,
                      LeaveRequest,
                      $LeaveRequestsTable
                    >(
                      currentTable: table,
                      referencedTable: $$LeaveTypesTableReferences
                          ._leaveRequestsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LeaveTypesTableReferences(
                            db,
                            table,
                            p0,
                          ).leaveRequestsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'leave_type_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LeaveTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveTypesTable,
      LeaveType,
      $$LeaveTypesTableFilterComposer,
      $$LeaveTypesTableOrderingComposer,
      $$LeaveTypesTableAnnotationComposer,
      $$LeaveTypesTableCreateCompanionBuilder,
      $$LeaveTypesTableUpdateCompanionBuilder,
      (LeaveType, $$LeaveTypesTableReferences),
      LeaveType,
      PrefetchHooks Function({bool leaveRequestsRefs})
    >;
typedef $$HolidaysTableCreateCompanionBuilder = HolidaysCompanion Function({
  Value<int> id,
  required String name,
  required DateTime date,
  Value<bool> optional,
});
typedef $$HolidaysTableUpdateCompanionBuilder = HolidaysCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> date,
  Value<bool> optional,
});

class $$HolidaysTableFilterComposer
    extends Composer<_$AppDatabase, $HolidaysTable> {
  $$HolidaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HolidaysTableOrderingComposer
    extends Composer<_$AppDatabase, $HolidaysTable> {
  $$HolidaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HolidaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $HolidaysTable> {
  $$HolidaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get optional =>
      $composableBuilder(column: $table.optional, builder: (column) => column);
}

class $$HolidaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HolidaysTable,
          Holiday,
          $$HolidaysTableFilterComposer,
          $$HolidaysTableOrderingComposer,
          $$HolidaysTableAnnotationComposer,
          $$HolidaysTableCreateCompanionBuilder,
          $$HolidaysTableUpdateCompanionBuilder,
          (Holiday, BaseReferences<_$AppDatabase, $HolidaysTable, Holiday>),
          Holiday,
          PrefetchHooks Function()
        > {
  $$HolidaysTableTableManager(_$AppDatabase db, $HolidaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HolidaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HolidaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HolidaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> optional = const Value.absent(),
              }) => HolidaysCompanion(
                id: id,
                name: name,
                date: date,
                optional: optional,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime date,
                Value<bool> optional = const Value.absent(),
              }) => HolidaysCompanion.insert(
                id: id,
                name: name,
                date: date,
                optional: optional,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HolidaysTable, Holiday>(table),
                  BaseReferences<_$AppDatabase, $HolidaysTable, Holiday>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HolidaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HolidaysTable,
      Holiday,
      $$HolidaysTableFilterComposer,
      $$HolidaysTableOrderingComposer,
      $$HolidaysTableAnnotationComposer,
      $$HolidaysTableCreateCompanionBuilder,
      $$HolidaysTableUpdateCompanionBuilder,
      (Holiday, BaseReferences<_$AppDatabase, $HolidaysTable, Holiday>),
      Holiday,
      PrefetchHooks Function()
    >;
typedef $$WfhAllowancesTableCreateCompanionBuilder =
    WfhAllowancesCompanion Function({
      Value<int> month,
      required int daysAllowed,
    });
typedef $$WfhAllowancesTableUpdateCompanionBuilder =
    WfhAllowancesCompanion Function({Value<int> month, Value<int> daysAllowed});

class $$WfhAllowancesTableFilterComposer
    extends Composer<_$AppDatabase, $WfhAllowancesTable> {
  $$WfhAllowancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysAllowed => $composableBuilder(
    column: $table.daysAllowed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WfhAllowancesTableOrderingComposer
    extends Composer<_$AppDatabase, $WfhAllowancesTable> {
  $$WfhAllowancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysAllowed => $composableBuilder(
    column: $table.daysAllowed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WfhAllowancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WfhAllowancesTable> {
  $$WfhAllowancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get daysAllowed => $composableBuilder(
    column: $table.daysAllowed,
    builder: (column) => column,
  );
}

class $$WfhAllowancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WfhAllowancesTable,
          WfhAllowance,
          $$WfhAllowancesTableFilterComposer,
          $$WfhAllowancesTableOrderingComposer,
          $$WfhAllowancesTableAnnotationComposer,
          $$WfhAllowancesTableCreateCompanionBuilder,
          $$WfhAllowancesTableUpdateCompanionBuilder,
          (
            WfhAllowance,
            BaseReferences<_$AppDatabase, $WfhAllowancesTable, WfhAllowance>,
          ),
          WfhAllowance,
          PrefetchHooks Function()
        > {
  $$WfhAllowancesTableTableManager(_$AppDatabase db, $WfhAllowancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WfhAllowancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WfhAllowancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WfhAllowancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> month = const Value.absent(),
            Value<int> daysAllowed = const Value.absent(),
          }) => WfhAllowancesCompanion(month: month, daysAllowed: daysAllowed),
          createCompanionCallback:
              ({
                Value<int> month = const Value.absent(),
                required int daysAllowed,
              }) => WfhAllowancesCompanion.insert(
                month: month,
                daysAllowed: daysAllowed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WfhAllowancesTable, WfhAllowance>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WfhAllowancesTable,
                    WfhAllowance
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WfhAllowancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WfhAllowancesTable,
      WfhAllowance,
      $$WfhAllowancesTableFilterComposer,
      $$WfhAllowancesTableOrderingComposer,
      $$WfhAllowancesTableAnnotationComposer,
      $$WfhAllowancesTableCreateCompanionBuilder,
      $$WfhAllowancesTableUpdateCompanionBuilder,
      (
        WfhAllowance,
        BaseReferences<_$AppDatabase, $WfhAllowancesTable, WfhAllowance>,
      ),
      WfhAllowance,
      PrefetchHooks Function()
    >;
typedef $$LeaveRequestsTableCreateCompanionBuilder =
    LeaveRequestsCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<int?> leaveTypeId,
      required DateTime startDate,
      required DateTime endDate,
      required double days,
      Value<String?> reason,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> appliedAt,
    });
typedef $$LeaveRequestsTableUpdateCompanionBuilder =
    LeaveRequestsCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<int?> leaveTypeId,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<double> days,
      Value<String?> reason,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> appliedAt,
    });

final class $$LeaveRequestsTableReferences
    extends BaseReferences<_$AppDatabase, $LeaveRequestsTable, LeaveRequest> {
  $$LeaveRequestsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LeaveTypesTable _leaveTypeIdTable(_$AppDatabase db) => db.leaveTypes
      .createAlias('leave_requests__leave_type_id__leave_types__id');

  $$LeaveTypesTableProcessedTableManager? get leaveTypeId {
    final $_column = $_itemColumn<int>('leave_type_id');
    if ($_column == null) return null;
    final manager = $$LeaveTypesTableTableManager(
      $_db,
      $_db.leaveTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_leaveTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LeaveRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveRequestsTable> {
  $$LeaveRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get days => $composableBuilder(
    column: $table.days,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LeaveTypesTableFilterComposer get leaveTypeId {
    final $$LeaveTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaveTypeId,
      referencedTable: $db.leaveTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveTypesTableFilterComposer(
            $db: $db,
            $table: $db.leaveTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeaveRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveRequestsTable> {
  $$LeaveRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get days => $composableBuilder(
    column: $table.days,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LeaveTypesTableOrderingComposer get leaveTypeId {
    final $$LeaveTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaveTypeId,
      referencedTable: $db.leaveTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveTypesTableOrderingComposer(
            $db: $db,
            $table: $db.leaveTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeaveRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveRequestsTable> {
  $$LeaveRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<double> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);

  $$LeaveTypesTableAnnotationComposer get leaveTypeId {
    final $$LeaveTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaveTypeId,
      referencedTable: $db.leaveTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.leaveTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeaveRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveRequestsTable,
          LeaveRequest,
          $$LeaveRequestsTableFilterComposer,
          $$LeaveRequestsTableOrderingComposer,
          $$LeaveRequestsTableAnnotationComposer,
          $$LeaveRequestsTableCreateCompanionBuilder,
          $$LeaveRequestsTableUpdateCompanionBuilder,
          (LeaveRequest, $$LeaveRequestsTableReferences),
          LeaveRequest,
          PrefetchHooks Function({bool leaveTypeId})
        > {
  $$LeaveRequestsTableTableManager(_$AppDatabase db, $LeaveRequestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int?> leaveTypeId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<double> days = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> appliedAt = const Value.absent(),
              }) => LeaveRequestsCompanion(
                id: id,
                category: category,
                leaveTypeId: leaveTypeId,
                startDate: startDate,
                endDate: endDate,
                days: days,
                reason: reason,
                status: status,
                createdAt: createdAt,
                appliedAt: appliedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int?> leaveTypeId = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required double days,
                Value<String?> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> appliedAt = const Value.absent(),
              }) => LeaveRequestsCompanion.insert(
                id: id,
                category: category,
                leaveTypeId: leaveTypeId,
                startDate: startDate,
                endDate: endDate,
                days: days,
                reason: reason,
                status: status,
                createdAt: createdAt,
                appliedAt: appliedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeaveRequestsTable, LeaveRequest>(table),
                  $$LeaveRequestsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({leaveTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (leaveTypeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.leaveTypeId,
                        referencedTable: $$LeaveRequestsTableReferences
                            ._leaveTypeIdTable(db),
                        referencedColumn: $$LeaveRequestsTableReferences
                            ._leaveTypeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LeaveRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveRequestsTable,
      LeaveRequest,
      $$LeaveRequestsTableFilterComposer,
      $$LeaveRequestsTableOrderingComposer,
      $$LeaveRequestsTableAnnotationComposer,
      $$LeaveRequestsTableCreateCompanionBuilder,
      $$LeaveRequestsTableUpdateCompanionBuilder,
      (LeaveRequest, $$LeaveRequestsTableReferences),
      LeaveRequest,
      PrefetchHooks Function({bool leaveTypeId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$RecipientsTableTableManager get recipients =>
      $$RecipientsTableTableManager(_db, _db.recipients);
  $$LeaveTypesTableTableManager get leaveTypes =>
      $$LeaveTypesTableTableManager(_db, _db.leaveTypes);
  $$HolidaysTableTableManager get holidays =>
      $$HolidaysTableTableManager(_db, _db.holidays);
  $$WfhAllowancesTableTableManager get wfhAllowances =>
      $$WfhAllowancesTableTableManager(_db, _db.wfhAllowances);
  $$LeaveRequestsTableTableManager get leaveRequests =>
      $$LeaveRequestsTableTableManager(_db, _db.leaveRequests);
}
