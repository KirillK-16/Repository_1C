
#Область КлиентскиеПеременные

&НаКлиенте
Перем ИдентификаторСтрокиОборудование, ИдентификаторСтрокиКластер1С;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ЗаполнитьТипыЭлементов();
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СгенерироватьНоду(Команда)
    
    ЭлементыКорневые = ЭтотОбъект.ПараметрыНоды.ПолучитьЭлементы();
    
    Для Каждого ТекЭлемент Из ЭлементыКорневые Цикл
        
        Если ТекЭлемент.Ключ = ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Оборудование") Тогда
            СгенерироватьОборудованиеНоды(ТекЭлемент);
        ИначеЕсли ТекЭлемент.Ключ = ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Кластер1С") Тогда
            СгенерироватьКластеры1СНоды(ТекЭлемент);
        КонецЕсли;
        
    КонецЦикла;
        
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНоду(Команда)
    
    ЗаписатьНодуНаСервере();
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПараметрыНодыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
    
    КлючJSON = ПараметрыПеретаскивания.Значение[0].КлючJSON;
    
    Если КлючJSON = "equipment" Тогда
        ПеретаскиваниеОборудование(ПараметрыПеретаскивания.Значение[0]);
    ИначеЕсли КлючJSON = "cluster1C" Тогда
        ПеретаскиваниеКластер1С(ПараметрыПеретаскивания.Значение[0]);
    ИначеЕсли КлючJSON = "workingServer1C" Тогда
        
        ТекИсточник = ПараметрыПеретаскивания.Значение[0];
        
        Получатель = ЭтотОбъект.ПараметрыНоды.НайтиПоИдентификатору(Строка);
        ЭлементыПолучатель = Получатель.ПолучитьЭлементы();
        
        ЭлементыТекИсточника = ТекИсточник.ПолучитьЭлементы();
        ЭлементНаименование = НайтиЭлементКоллекции(ЭлементыТекИсточника, "КлючJSON", "description");
        
        НовЭлемент = ЭлементыПолучатель.Добавить();
        НовЭлемент.Ключ = ЭлементНаименование.Значение;
        НовЭлемент.ИндексКартинки = ТекИсточник.ИндексКартинки;
        НовЭлемент.Значение = "";
        НовЭлемент.КлючJSON = ТекИсточник.КлючJSON;
        НовЭлемент.ЗначениеШаблон = ЭлементНаименование.Значение;
        
        КопироватьШаблон(ТекИсточник, НовЭлемент);
        
    КонецЕсли;
    
    СтандартнаяОбработка = Ложь;
    
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыНодыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
    
    Если
        ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив")
        И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("ДанныеФормыЭлементДерева")
        И ПараметрыПеретаскивания.Значение[0].Свойство("КлючJSON")
    Тогда
        ПараметрыПеретаскивания.Действие = ПроверкаПеретаскиванияПоКлючу(ПараметрыПеретаскивания.Значение[0].КлючJSON, Строка);
    Иначе
        ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
    КонецЕсли;
    
    СтандартнаяОбработка = Ложь;
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнитьТип

&НаСервере
Процедура ЗаполнитьТипыЭлементов()
    
    ЭлементыКорневые = ЭтотОбъект.ТипыЭлементов.ПолучитьЭлементы();
    
    ЗаполнитьТипОборудование(ЭлементыКорневые);
    ЗаполнитьТипКластер1С(ЭлементыКорневые);
           
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипОборудование(ЭлементыКорневые)
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    
    НовЭлемент.Ключ = Перечисления.ТипЭлементаПлощадки.Оборудование;
    НовЭлемент.ИндексКартинки = 12;
    НовЭлемент.Значение = "";
    НовЭлемент.КлючJSON = "equipment";
    
    ЭлементыРеквизиты = НовЭлемент.ПолучитьЭлементы();
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Наименование";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "description";
    НовЭлемент.Значение = "SRV1C[ЕдиницаМасштабирования]-[№]";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Хост";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "host";
    НовЭлемент.Значение = "SRV1C[ЕдиницаМасштабирования]-[№]";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Сбор счетчиков";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "collectPerformanceData";
    НовЭлемент.Значение = 2;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Тип ОС";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "typeOs";
    НовЭлемент.Значение = Перечисления.ТипОС.Windows;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Язык ОС";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "languageOS";
    НовЭлемент.Значение = Перечисления.ЯзыкиСистемы.Английский;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Проверять доступность";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "checkAvailability";
    НовЭлемент.Значение = Истина;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Таймаут, сек.";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "timeout";
    НовЭлемент.Значение = 3;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Период контроля, сек.";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "сontrolPeriod";
    НовЭлемент.Значение = 120;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Минимальная доступность, %";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "мinPercentageAvailability";
    НовЭлемент.Значение = 90;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Допустимо нет данных, сек.";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "noDataAllowed";
    НовЭлемент.Значение = 240;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Роли оборудования";
    НовЭлемент.ИндексКартинки = 39;
    НовЭлемент.КлючJSON = "role";
    НовЭлемент.Значение = "";
    
    ЭлементыРоли = НовЭлемент.ПолучитьЭлементы();
    
    НовЭлемент = ЭлементыРоли.Добавить();
    НовЭлемент.Ключ = "Сервер с ОС Windows";
    НовЭлемент.ИндексКартинки = 12;
    НовЭлемент.КлючJSON = "";
    НовЭлемент.Значение = "Сервер с ОС Windows";
    
    НовЭлемент = ЭлементыРоли.Добавить();
    НовЭлемент.Ключ = "Рабочий сервер 1С";
    НовЭлемент.ИндексКартинки = 10;
    НовЭлемент.КлючJSON = "";
    НовЭлемент.Значение = "Рабочий сервер 1С";
    
    НовЭлемент = ЭлементыРоли.Добавить();
    НовЭлемент.Ключ = "MS SQL";
    НовЭлемент.ИндексКартинки = 7;
    НовЭлемент.КлючJSON = "";
    НовЭлемент.Значение = "MS SQL";
    
    НовЭлемент = ЭлементыРоли.Добавить();
    НовЭлемент.Ключ = "Apache";
    НовЭлемент.ИндексКартинки = 2;
    НовЭлемент.КлючJSON = "";
    НовЭлемент.Значение = "Apache";
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипКластер1С(ЭлементыКорневые)
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = Перечисления.ТипЭлементаПлощадки.Кластер1С;
    НовЭлемент.ИндексКартинки = 18;
    НовЭлемент.Значение = "";
    НовЭлемент.КлючJSON = "cluster1C";
    
    ЭлементыРеквизиты = НовЭлемент.ПолучитьЭлементы();
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Наименование";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "description";
    НовЭлемент.Значение = "SRV1C[ЕдиницаМасштабирования]-[№]";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Тип подключения";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "typeConnection";
    НовЭлемент.Значение = "RAS";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Основной порт менеджера кластера";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "portRmngr";
    НовЭлемент.Значение = 1541;
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Администратор кластера";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "login";
    НовЭлемент.Значение = "Administrator";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Пароль администратора кластера";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "password";
    НовЭлемент.Значение = "";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Сервер администрирования";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "serverRAS";
    НовЭлемент.Значение = "SRV1C[ЕдиницаМасштабирования]-[№]:1545";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Каталог клиента администрирования";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "catalogRAC";
    НовЭлемент.Значение = "C:\Program Files\1cv8\8.3.12.1159\bin";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Версия платформы";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "versionPlatform";
    НовЭлемент.Значение = "8.3.12.1159";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Ответственный";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "responsibleUser";
    НовЭлемент.Значение = "Администратор";
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Контроль потребления памяти";
    НовЭлемент.ИндексКартинки = 20;
    НовЭлемент.КлючJSON = "memoryMonitoring";
    НовЭлемент.Значение = "";
    
    ЗаполнитьТипКонтрольПотребленияПамяти(НовЭлемент.ПолучитьЭлементы());
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Рабочий сервер 1С";
    НовЭлемент.ИндексКартинки = 10;
    НовЭлемент.КлючJSON = "workingServer1C";
    НовЭлемент.Значение = "";
    
    ЗаполнитьТипРабочийСервер1С(НовЭлемент.ПолучитьЭлементы());
    
    
    НовЭлемент = ЭлементыРеквизиты.Добавить();
    НовЭлемент.Ключ = "Информационная база";
    НовЭлемент.ИндексКартинки = 23;
    НовЭлемент.КлючJSON = "infoBase";
    НовЭлемент.Значение = "";
    
    ЗаполнитьТипИнформационнаяБаза(НовЭлемент.ПолучитьЭлементы());
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипКонтрольПотребленияПамяти(ЭлементыКорневые)
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Наименование";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "description";
    НовЭлемент.Значение = "Мониторинг кластера SRV1C[ЕдиницаМасштабирования]-[№]";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Ответственный";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "responsibleUser";
    НовЭлемент.Значение = "Контроль памяти";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Потребление памяти раб. процессом, Мб";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "memoryThreshold";
    НовЭлемент.Значение = 4096;
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Автоматически удалять собранные данные";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "automaticallyDelete";
    НовЭлемент.Значение = Истина;
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Период хранения собранных данных, час.";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "storeDataHour";
    НовЭлемент.Значение = 48;
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Выполнять";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "start";
    НовЭлемент.Значение = Истина;
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Расписание";
    НовЭлемент.ИндексКартинки = 40;
    НовЭлемент.КлючJSON = "schedule";
    НовЭлемент.Значение = "";
    
    ЭлементыРасписания = НовЭлемент.ПолучитьЭлементы();
    НовЭлементРасписание = ЭлементыРасписания.Добавить();
    НовЭлементРасписание.Ключ = "Период повтора, дн.";
    НовЭлементРасписание.ИндексКартинки = 38;
    НовЭлементРасписание.КлючJSON = "repeatDays";
    НовЭлементРасписание.Значение = 1;
    
    НовЭлементРасписание = ЭлементыРасписания.Добавить();
    НовЭлементРасписание.Ключ = "Период повтора в течение дня, сек.";
    НовЭлементРасписание.ИндексКартинки = 38;
    НовЭлементРасписание.КлючJSON = "repeatSeconds";
    НовЭлементРасписание.Значение = 60;
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипРабочийСервер1С(ЭлементыКорневые)
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Наименование";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "description";
    НовЭлемент.Значение = "SRV1C[ЕдиницаМасштабирования]-[№]";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Диапазон IP портов";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "portRange";
    НовЭлемент.Значение = "1560:1591";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Сетевой каталог настроек ТЖ (logcfg.xml)";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "settingsDirectoryNetwork";
    НовЭлемент.Значение = "";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Локальный каталог настроек ТЖ (logcfg.xml)";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "settingsDirectory";
    НовЭлемент.Значение = "";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Сетевой каталог сбора данных (*.log)";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "dataDirectoryNetwork";
    НовЭлемент.Значение = "";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Локальный каталог сбора данных (*.log)";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "dataDirectory";
    НовЭлемент.Значение = "";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Каталог временных файлов";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "tempDirectory";
    НовЭлемент.Значение = "";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Контроль устойчивости";
    НовЭлемент.ИндексКартинки = 31;
    НовЭлемент.КлючJSON = "controlCollectionDumps";
    НовЭлемент.Значение = "";
    
    ЗаполнитьКонтрольУстойчивости(НовЭлемент.ПолучитьЭлементы());
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтрольУстойчивости(ЭлементыКорневые)
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Наименование";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "description";
    НовЭлемент.Значение = "Контроль устойчивости для SRV1C[ЕдиницаМасштабирования]-[№]";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Каталог экспорта дампов";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "folderExportDumps";
    НовЭлемент.Значение = "";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Использовать агента";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "agentEnable";
    НовЭлемент.Значение = Истина;
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Выполнять";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "start";
    НовЭлемент.Значение = Истина;
    
    
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипИнформационнаяБаза(ЭлементыКорневые)
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Наименование";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "description";
    НовЭлемент.Значение = "ea_[ЕдиницаМасштабирования]";
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Контроль подключений";
    НовЭлемент.ИндексКартинки = 25;
    НовЭлемент.КлючJSON = "connectionMonitoring";
    НовЭлемент.Значение = "";
    
    ЗаполнитьКонтрольПодключений(НовЭлемент.ПолучитьЭлементы());
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтрольПодключений(ЭлементыКорневые)
    
    НовЭлемент = ЭлементыКорневые.Добавить();
    НовЭлемент.Ключ = "Наименование";
    НовЭлемент.ИндексКартинки = 38;
    НовЭлемент.КлючJSON = "description";
    НовЭлемент.Значение = "Контроль подключений для ea_[ЕдиницаМасштабирования]";
    
КонецПроцедуры

#КонецОбласти

#Область Перетаскивание

&НаКлиенте
Процедура ПеретаскиваниеОборудование(ШаблонОборудование)
    
    ЭлементыКорневые = ЭтотОбъект.ПараметрыНоды.ПолучитьЭлементы();
    ЭлементГруппаОборудование = ЭлементГруппаОборудования(ЭлементыКорневые);
    
    ПеретаскиваниеОбщая(ШаблонОборудование, ЭлементГруппаОборудование, 12);
    
КонецПроцедуры

&НаКлиенте
Процедура ПеретаскиваниеКластер1С(ШаблонКластер)
    
    ЭлементыКорневые = ЭтотОбъект.ПараметрыНоды.ПолучитьЭлементы();
    ЭлементГруппаКластер1С = ЭлементГруппаКластер1С(ЭлементыКорневые);
    
    ПеретаскиваниеОбщая(ШаблонКластер, ЭлементГруппаКластер1С, 18);
    
КонецПроцедуры

&НаКлиенте
Процедура ПеретаскиваниеОбщая(Шаблон, ЭлементГруппа, ИндексКартинки)
    
    ЭлементыРеквизиты = Шаблон.ПолучитьЭлементы();
    
    ЭлементыГруппы = ЭлементГруппа.ПолучитьЭлементы();
    Элемент = ЭлементыГруппы.Добавить();
    
    ЭлементНаименование = НайтиЭлементКоллекции(ЭлементыРеквизиты, "Ключ", "Наименование");
    
    Элемент.Ключ = ЭлементНаименование.Значение;
    Элемент.КлючJSON = ЭлементНаименование.КлючJSON;
    Элемент.ИндексКартинки = ИндексКартинки;
    Элемент.Значение = "";
    Элемент.ЗначениеШаблон = ЭлементНаименование.Значение;
    
    КопироватьШаблон(Шаблон, Элемент);
    
КонецПроцедуры

&НаКлиенте
Процедура КопироватьШаблон(Источник, Получатель)
    
    ЭлементыИсточник = Источник.ПолучитьЭлементы();
    ЭлементыПолучатель = Получатель.ПолучитьЭлементы();
    
    Для Каждого ТекИсточник Из ЭлементыИсточник Цикл
        
        Если ТекИсточник.КлючJSON = "description" Тогда
            //Ничего не делаем, т.к. наименование у родителя в ключе
        ИначеЕсли
            ТекИсточник.КлючJSON = "memoryMonitoring"
            ИЛИ ТекИсточник.КлючJSON = "workingServer1C"
            ИЛИ ТекИсточник.КлючJSON = "controlCollectionDumps"
            ИЛИ ТекИсточник.КлючJSON = "infoBase"
            ИЛИ ТекИсточник.КлючJSON = "connectionMonitoring"
        Тогда
            
            ЭлементыТекИсточника = ТекИсточник.ПолучитьЭлементы();
            ЭлементНаименование = НайтиЭлементКоллекции(ЭлементыТекИсточника, "КлючJSON", "description");
            
            НовЭлемент = ЭлементыПолучатель.Добавить();
            НовЭлемент.Ключ = ЭлементНаименование.Значение;
            НовЭлемент.ИндексКартинки = ТекИсточник.ИндексКартинки;
            НовЭлемент.Значение = "";
            НовЭлемент.КлючJSON = ТекИсточник.КлючJSON;
            НовЭлемент.ЗначениеШаблон = ЭлементНаименование.Значение;
            
            КопироватьШаблон(ТекИсточник, НовЭлемент);
            
        Иначе    
            
            НовЭлемент = ЭлементыПолучатель.Добавить();
            НовЭлемент.Ключ = ТекИсточник.Ключ;
            НовЭлемент.ИндексКартинки = ТекИсточник.ИндексКартинки;
            НовЭлемент.Значение = ТекИсточник.Значение;
            НовЭлемент.КлючJSON = ТекИсточник.КлючJSON;
            НовЭлемент.ЗначениеШаблон = ТекИсточник.Значение;
                        
            ЭлементыТекИсточника = ТекИсточник.ПолучитьЭлементы();
            
            КопироватьШаблон(ТекИсточник, НовЭлемент);
                        
        КонецЕсли;
        
    КонецЦикла;
    
КонецПроцедуры

#КонецОбласти

#Область ЭлементГруппа

&НаКлиенте
Функция ЭлементГруппаОборудования(ЭлементыКорневые)
    
    ЭлементГруппаОборудование = НайтиЭлементКоллекции(ЭлементыКорневые, "Ключ", ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Оборудование"));
    
    Если ЭлементГруппаОборудование = Неопределено Тогда
        
        ЭлементГруппаОборудование = ЭлементыКорневые.Добавить();
        ЭлементГруппаОборудование.Ключ = ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Оборудование");
        ЭлементГруппаОборудование.ИндексКартинки = 11;
        ЭлементГруппаОборудование.Значение = "";
        
        ИдентификаторСтрокиОборудование = ЭлементГруппаОборудование.ПолучитьИдентификатор();
        ПодключитьОбработчикОжидания("РазвернутьОборудование", 0.1, Истина);
                
    КонецЕсли;
    
    Возврат ЭлементГруппаОборудование;
    
КонецФункции

&НаКлиенте
Функция ЭлементГруппаКластер1С(ЭлементыКорневые)
    
    ЭлементГруппаКластер1С = НайтиЭлементКоллекции(ЭлементыКорневые, "Ключ", ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Кластер1С"));
    
    Если ЭлементГруппаКластер1С = Неопределено Тогда
        
        ЭлементГруппаКластер1С = ЭлементыКорневые.Добавить();
        ЭлементГруппаКластер1С.Ключ = ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Кластер1С");
        ЭлементГруппаКластер1С.ИндексКартинки = 17;
        ЭлементГруппаКластер1С.Значение = "";
        
        ИдентификаторСтрокиКластер1С = ЭлементГруппаКластер1С.ПолучитьИдентификатор();
        ПодключитьОбработчикОжидания("РазвернутьКластер1С", 0.1, Истина);
        
    КонецЕсли;
    
    Возврат ЭлементГруппаКластер1С;
    
КонецФункции

#КонецОбласти

#Область РазвернутьУзел

&НаКлиенте
Процедура РазвернутьОборудование() Экспорт
    
    Если ИдентификаторСтрокиОборудование <> Неопределено Тогда 
        Элементы.ПараметрыНоды.Развернуть(ИдентификаторСтрокиОборудование);
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьКластер1С() Экспорт
    
    Если ИдентификаторСтрокиКластер1С <> Неопределено Тогда
        Элементы.ПараметрыНоды.Развернуть(ИдентификаторСтрокиКластер1С);
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область Сгенерировать

&НаКлиенте
Процедура СгенерироватьОборудованиеНоды(Оборудование)
    
    СгенерироватьОбщая(Оборудование);
    
КонецПроцедуры

&НаКлиенте
Процедура СгенерироватьКластеры1СНоды(Кластеры1С)
    СгенерироватьОбщая(Кластеры1С);
КонецПроцедуры

&НаКлиенте
Процедура СгенерироватьОбщая(Группа)
    
    ЭлементыГруппа = Группа.ПолучитьЭлементы();
    
    ПорядковыйНомер = 0;
    ПорядковыйНомерРабочегоСервера = 0;
    
    Для Каждого ТекЭлемент Из ЭлементыГруппа Цикл
        
        ПорядковыйНомер = ПорядковыйНомер + 1;
        
        ТекЭлемент.Ключ = ЗаменитьШаблон(ТекЭлемент.ЗначениеШаблон, ПорядковыйНомер);
        
        ЭлементыРеквизиты = ТекЭлемент.ПолучитьЭлементы();
        Для Каждого ТекЭлементРеквизит Из ЭлементыРеквизиты Цикл
            
            Если ТекЭлементРеквизит.КлючJSON = "host" Тогда
                ТекЭлементРеквизит.Значение = ЗаменитьШаблон(ТекЭлементРеквизит.ЗначениеШаблон, ПорядковыйНомер);
            ИначеЕсли ТекЭлементРеквизит.КлючJSON = "serverRAS" Тогда
                ТекЭлементРеквизит.Значение = ЗаменитьШаблон(ТекЭлементРеквизит.ЗначениеШаблон, ПорядковыйНомер);
            ИначеЕсли ТекЭлементРеквизит.КлючJSON = "memoryMonitoring" Тогда   
                ТекЭлементРеквизит.Ключ = ЗаменитьШаблон(ТекЭлементРеквизит.ЗначениеШаблон, ПорядковыйНомер);
            ИначеЕсли ТекЭлементРеквизит.КлючJSON = "workingServer1C" Тогда
                
                ПорядковыйНомерРабочегоСервера = ПорядковыйНомерРабочегоСервера + 1;
                ТекЭлементРеквизит.Ключ = ЗаменитьШаблон(ТекЭлементРеквизит.ЗначениеШаблон, ПорядковыйНомерРабочегоСервера);    
                
                Для Каждого ТекЭлементРеквизитРабочегоСервера Из ТекЭлементРеквизит.ПолучитьЭлементы() Цикл
                    Если ТекЭлементРеквизитРабочегоСервера.КлючJSON = "controlCollectionDumps" Тогда
                        ТекЭлементРеквизитРабочегоСервера.Ключ = ЗаменитьШаблон(ТекЭлементРеквизитРабочегоСервера.ЗначениеШаблон, ПорядковыйНомерРабочегоСервера);
                    КонецЕсли;
                КонецЦикла;
                
            ИначеЕсли ТекЭлементРеквизит.КлючJSON = "infoBase" Тогда
                
                ТекЭлементРеквизит.Ключ = ЗаменитьШаблон(ТекЭлементРеквизит.ЗначениеШаблон, ПорядковыйНомер);
                
                Для Каждого ТекЭлементИнформационнаяБаза Из ТекЭлементРеквизит.ПолучитьЭлементы() Цикл
                    
                    Если ТекЭлементИнформационнаяБаза.КлючJSON = "connectionMonitoring" Тогда
                        ТекЭлементИнформационнаяБаза.Ключ = ЗаменитьШаблон(ТекЭлементИнформационнаяБаза.ЗначениеШаблон, ПорядковыйНомер);
                    КонецЕсли;
                    
                КонецЦикла;
                                                
            КонецЕсли;
            
        КонецЦикла;
        
    КонецЦикла;    
    
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция ПроверкаПеретаскиванияПоКлючу(Ключ, Строка)
    
    Результат = ДействиеПеретаскивания.Отмена; 
    
    Если Ключ = "equipment" Тогда
        Результат = ДействиеПеретаскивания.Выбор;
    ИначеЕсли Ключ = "cluster1C" Тогда
        Результат = ДействиеПеретаскивания.Выбор;
    ИначеЕсли Ключ = "workingServer1C" Тогда
        
        Если Строка <> Неопределено Тогда
            Куда = ЭтотОбъект.ПараметрыНоды.НайтиПоИдентификатору(Строка);
            РодительКуда = Куда.ПолучитьРодителя();
            Если РодительКуда <> Неопределено И РодительКуда.Ключ = ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Кластер1С") Тогда
                Результат = ДействиеПеретаскивания.Выбор;
            КонецЕсли;
        КонецЕсли;
        
    КонецЕсли;
    
    Возврат Результат;    
    
КонецФункции

&НаКлиенте
Функция НайтиЭлементКоллекции(Коллекция, ИмяРеквизита, Значение)
    
    ЭлементКоллекции = Неопределено;
    
    Для ТекИндекс = 0 По Коллекция.Количество() - 1 Цикл
        
        Если Коллекция[ТекИндекс][ИмяРеквизита] = Значение Тогда
            ЭлементКоллекции = Коллекция[ТекИндекс];
            Прервать;
        КонецЕсли;
        
    КонецЦикла;
    
    Возврат ЭлементКоллекции;
        
КонецФункции

&НаКлиенте
Функция ЗаменитьШаблон(Значение, Номер)
    
    НовоеЗначение = СтрЗаменить(Значение, "[ЕдиницаМасштабирования]", ЭтотОбъект.НаименованиеЕдиницыМасштабирования);
    НовоеЗначение = СтрЗаменить(НовоеЗначение, "[№]", Номер);
    
    Возврат НовоеЗначение;
    
КонецФункции

&НаСервере
Процедура ЗаписатьНодуНаСервере()
    
    СтруктураНоды = Новый Соответствие;
    СтруктураНоды.Вставить("equipmentLocation", ЭтотОбъект.ПлощадкаЭксплуатации.Наименование);
    
    ЭлементыКорневые = ЭтотОбъект.ПараметрыНоды.ПолучитьЭлементы();
    
    Для Каждого ТекЭлемент Из ЭлементыКорневые Цикл
        
        Если ТекЭлемент.Ключ = Перечисления.ТипЭлементаПлощадки.Оборудование Тогда
            ДобавитьОборудованиеНоды(СтруктураНоды, ТекЭлемент);
        ИначеЕсли ТекЭлемент.Ключ = Перечисления.ТипЭлементаПлощадки.Кластер1С Тогда
            ДобавитьКластеры1СНоды(СтруктураНоды, ТекЭлемент);
        КонецЕсли;
        
    КонецЦикла;
    
КонецПроцедуры

&НаСервере
Процедура ДобавитьОборудованиеНоды(ПараметрыКоманды, Оборудование)
    
    ЭлементыОборудование = Оборудование.ПолучитьЭлементы();
    
    Оборудование = Новый Массив;
    
    Для Каждого ТекЭлемент Из ЭлементыОборудование Цикл
        
        ЕдиницаОборудования = Новый Соответствие;
        ЕдиницаОборудования.Вставить(ТекЭлемент.КлючJSON, ТекЭлемент.Ключ);
        
        ЭлементыРеквизиты = ТекЭлемент.ПолучитьЭлементы();
        Для Каждого ТекЭлементРеквизит Из ЭлементыРеквизиты Цикл
            
            Если ТекЭлементРеквизит.КлючJSON <> "role" Тогда
                
                ЕдиницаОборудования.Вставить(ТекЭлементРеквизит.КлючJSON, Строка(ТекЭлементРеквизит.Значение));
                
            Иначе
                
                РолиОборудования = Новый Массив;
                
                ЭлементыРоли = ТекЭлементРеквизит.ПолучитьЭлементы();
                Для Каждого ТекЭлементРоль Из ЭлементыРоли Цикл
                    РолиОборудования.Добавить(Строка(ТекЭлементРоль.Значение));
                КонецЦикла;
                
                ЕдиницаОборудования.Вставить(ТекЭлементРеквизит.КлючJSON, РолиОборудования);
                
            КонецЕсли;
            
        КонецЦикла;
                
        Оборудование.Добавить(ЕдиницаОборудования);
        
    КонецЦикла;
    
    ПараметрыКоманды.Вставить("equipment", Оборудование);
        
КонецПроцедуры

&НаСервере
Процедура ДобавитьКластеры1СНоды(ПараметрыКоманды, Кластеры1С)
    
    ЭлементыКластеры1С = Кластеры1С.ПолучитьЭлементы();
    
    Кластеры1С = Новый Массив;
    
    Для Каждого ТекЭлемент Из ЭлементыКластеры1С Цикл
        
        ПараметрыКластера = Новый Соответствие;
        ПараметрыКластера.Вставить(ТекЭлемент.КлючJSON, ТекЭлемент.Ключ);
        
        РабочиеСерверы1С = Новый Массив;
        
        ЭлементыРеквизиты = ТекЭлемент.ПолучитьЭлементы();
        Для Каждого ТекЭлементРеквизит Из ЭлементыРеквизиты Цикл
            
            Если ТекЭлементРеквизит.КлючJSON = "memoryMonitoring" Тогда
                
                КонтрольПотребленияПамяти = Новый Соответствие;
                КонтрольПотребленияПамяти.Вставить("description", ТекЭлементРеквизит.Ключ);
                
                ЭлементыРеквизитыКонтрольПотребленияПамяти = ТекЭлементРеквизит.ПолучитьЭлементы();
                Для Каждого ТекЭлементКонтрольПотребленияПамяти Из ЭлементыРеквизитыКонтрольПотребленияПамяти Цикл
                    
                    Если ТекЭлементКонтрольПотребленияПамяти.КлючJSON = "schedule" Тогда
                        
                        КонтрольПотребленияПамятиРассписание = Новый Соответствие;
                        ЭлементыРасписание = ТекЭлементКонтрольПотребленияПамяти.ПолучитьЭлементы();
                        Для Каждого ТекЭлементРасписание Из ЭлементыРасписание Цикл
                            КонтрольПотребленияПамятиРассписание.Вставить(ТекЭлементРасписание.КлючJSON, Строка(ТекЭлементРасписание.Значение));
                        КонецЦикла;
                        
                        КонтрольПотребленияПамяти.Вставить(ТекЭлементКонтрольПотребленияПамяти.КлючJSON, КонтрольПотребленияПамятиРассписание); 
                                                
                    Иначе
                        КонтрольПотребленияПамяти.Вставить(ТекЭлементКонтрольПотребленияПамяти.КлючJSON, Строка(ТекЭлементКонтрольПотребленияПамяти.Значение));
                    КонецЕсли;
                    
                КонецЦикла;
                
                ПараметрыКластера.Вставить(ТекЭлементРеквизит.КлючJSON, КонтрольПотребленияПамяти);
                
            ИначеЕсли ТекЭлементРеквизит.КлючJSON = "workingServer1C" Тогда
                
                ПараметрыРабочегоСервера1С = Новый Соответствие;
                ПараметрыРабочегоСервера1С.Вставить("description", ТекЭлементРеквизит.Ключ);
                ПараметрыРабочегоСервера1С.Вставить("equipment", ТекЭлементРеквизит.Ключ);
                ПараметрыРабочегоСервера1С.Вставить("cluster1C", ТекЭлемент.Ключ);
                
                Для Каждого ТекЭлементРабочийСервер Из ТекЭлементРеквизит.ПолучитьЭлементы() Цикл
                    
                    Если ТекЭлементРабочийСервер.КлючJSON = "controlCollectionDumps" Тогда
                        
                        ПараметрыКонтрольУстойчивости = Новый Соответствие;
                        ПараметрыКонтрольУстойчивости.Вставить("description", ТекЭлементРабочийСервер.Ключ);
                        Для Каждого ТекЭлементКонтрольУстойчивости Из ТекЭлементРабочийСервер.ПолучитьЭлементы() Цикл
                            ПараметрыКонтрольУстойчивости.Вставить(ТекЭлементКонтрольУстойчивости.КлючJSON, Строка(ТекЭлементКонтрольУстойчивости.Значение));
                        КонецЦикла;
                        
                        ПараметрыРабочегоСервера1С.Вставить(ТекЭлементРабочийСервер.КлючJSON, ПараметрыКонтрольУстойчивости); 
                        
                    Иначе
                        ПараметрыРабочегоСервера1С.Вставить(ТекЭлементРабочийСервер.КлючJSON, Строка(ТекЭлементРабочийСервер.Значение)); 
                    КонецЕсли;
                
                КонецЦикла;
                
                РабочиеСерверы1С.Добавить(ПараметрыРабочегоСервера1С);
                                
            Иначе
                
                ПараметрыКластера.Вставить(ТекЭлементРеквизит.КлючJSON, Строка(ТекЭлементРеквизит.Значение));
                
            КонецЕсли;
            
        КонецЦикла;
        
        Кластеры1С.Добавить(ПараметрыКластера);
        
    КонецЦикла;
    
    ПараметрыКоманды.Вставить("cluster1C", Кластеры1С);
    ПараметрыКоманды.Вставить("workingServer1C", РабочиеСерверы1С);        
        
КонецПроцедуры

#КонецОбласти
