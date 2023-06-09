
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ИнициализироватьКомпоновщик();
    
    Если ЭтотОбъект.Параметры.Свойство("Компоновщик") Тогда
        
        НовыйКомпоновщик = ЭтотОбъект.Параметры.Компоновщик;
        ЭтотОбъект.Компоновщик.ЗагрузитьНастройки(НовыйКомпоновщик.ПолучитьНастройки());
        
        ГруппаБыстрыйОтбор = Неопределено;
        ГруппаТипЭлементаРодитель = Неопределено;
        ГруппаСкрыть = Неопределено;
        ТипЭлементаРодитель = Неопределено;
        
        Для Каждого ТекЭлемент Из ЭтотОбъект.Компоновщик.Настройки.Отбор.Элементы Цикл
            
            Если ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") И ТекЭлемент.ИдентификаторПользовательскойНастройки = "ae910bb6-39eb-457c-bdba-f5ac90e667f0" Тогда
                ГруппаБыстрыйОтбор = ТекЭлемент;
            КонецЕсли;
            
            Если ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") И ТекЭлемент.ИдентификаторПользовательскойНастройки = "2600e275-da18-4ffc-9852-33f2797f33db" Тогда
                ГруппаТипЭлементаРодитель = ТекЭлемент;
            КонецЕсли;
            
            Если ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") И ТекЭлемент.ИдентификаторПользовательскойНастройки = "06e1652e-9a24-4b37-a095-4791eb237706" Тогда
                ГруппаСкрыть = ТекЭлемент;
            КонецЕсли;
            
            Если ТипЗнч(ТекЭлемент) = Тип("ЭлементОтбораКомпоновкиДанных") И ТекЭлемент.ИдентификаторПользовательскойНастройки = "2cd901a5-e06f-481d-bd2e-9b1cb8873e61" Тогда
                ТипЭлементаРодитель = ТекЭлемент;
            КонецЕсли;
            
        КонецЦикла;
        
        Если ГруппаБыстрыйОтбор <> Неопределено Тогда
            ЭтотОбъект.Компоновщик.Настройки.Отбор.Элементы.Удалить(ГруппаБыстрыйОтбор);
        КонецЕсли;
        
        Если ГруппаТипЭлементаРодитель <> Неопределено Тогда
            ЭтотОбъект.Компоновщик.Настройки.Отбор.Элементы.Удалить(ГруппаТипЭлементаРодитель);
        КонецЕсли;
        
        Если ГруппаСкрыть <> Неопределено Тогда
            ЭтотОбъект.Компоновщик.Настройки.Отбор.Элементы.Удалить(ГруппаСкрыть);
        КонецЕсли;
        
        Если ТипЭлементаРодитель <> Неопределено Тогда
            ЭтотОбъект.Компоновщик.Настройки.Отбор.Элементы.Удалить(ТипЭлементаРодитель);
        КонецЕсли;
                
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьОтбор(Команда)
        
    СписокГрупп = Новый СписокЗначений;
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаКонтрольПотребленияПамяти"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаАнализВызововКластера1С"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаКонтрольНагрузочныхТестов"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаКонтрольПодключений"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаКонтрольПроизводительности"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаКонтрольРегламентныхЗаданий"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаКонтрольУстойчивости"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаМониторингСистемныхОшибок"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаОценкаПользователей"));
    СписокГрупп.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ГруппаРабочиеСерверы1С"));
    
    НовЭлемент = ЭтотОбъект.Компоновщик.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    НовЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипЭлементаРодитель");
    НовЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
    НовЭлемент.ПравоеЗначение = СписокГрупп;
    НовЭлемент.ИдентификаторПользовательскойНастройки = "2cd901a5-e06f-481d-bd2e-9b1cb8873e61";
    
    ЭтотОбъект.Закрыть(ЭтотОбъект.Компоновщик);    
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщик()
    
    СКД = Новый СхемаКомпоновкиДанных();
	ИсточникСКД = СКД.ИсточникиДанных.Добавить();
	ИсточникСКД.Имя = "ИсточникДанных1";
	ИсточникСКД.ТипИсточникаДанных = "local";
    
    НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
    НаборДанных.ИсточникДанных = ИсточникСКД.Имя;
    НаборДанных.Имя = "НаборДанных1";
    НаборДанных.ИмяОбъекта = "НаборДанных1";
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "Наименование";
    Поле.ПутьКДанным = "Наименование";
    Поле.Заголовок = "Наименование";
    Поле.ТипЗначения = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(150));
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "ТипЭлемента";
    Поле.ПутьКДанным = "ТипЭлемента";
    Поле.Заголовок = "Тип элемента";
    Поле.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.ТипЭлементаПлощадки");
    Поле.ОграничениеИспользованияРеквизитов.Условие = Истина;
    Поле.УстановитьДоступныеЗначения(ДоступныеЗначенияТипЭлемента());
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "Площадка";
    Поле.ПутьКДанным = "Площадка";
    Поле.Заголовок = "Площадка";
    Поле.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ПлощадкиЭксплуатации");
    Поле.ОграничениеИспользованияРеквизитов.Условие = Истина;
    ПараметрРедактированияФормаВыбора = Поле.ПараметрыРедактирования.Элементы.Найти("ФормаВыбора");
    ПараметрРедактированияФормаВыбора.Использование = Истина;
    ПараметрРедактированияФормаВыбора.Значение = "Справочник.ПлощадкиЭксплуатации.Форма.ФормаВыбораПлощадки";
        
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "Выполняется";
    Поле.ПутьКДанным = "Выполняется";
    Поле.Заголовок = "Выполняется";
    Поле.ТипЗначения = Новый ОписаниеТипов("Булево");
        
    URLСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
    Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
    
КонецПроцедуры

&НаСервере
Функция ДоступныеЗначенияТипЭлемента()
    
    ДоступныеЗначения = Новый СписокЗначений;
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.MSSQL"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.PostgreSQL"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.VMware"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.АнализВызововКластера1С"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ВебСерверApache"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ВебСерверIIS"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ИнформационнаяБаза"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Кластер1С"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.КонтрольНагрузочныхТестов"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.КонтрольПодключений"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.КонтрольПотребленияПамяти"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.КонтрольПроизводительности"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.КонтрольРегламентныхЗаданий"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.КонтрольУстойчивости"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.МониторингСистемныхОшибок"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Оборудование"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Площадка"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Публикация"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.РабочийСервер1С"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.РабочийСерверКластера1С"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.ТерминальныйСервер"));
    ДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипЭлементаПлощадки.Шлюз"));
    
    Возврат ДоступныеЗначения;
    
КонецФункции
    

#КонецОбласти
