
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Если ЗначениеЗаполнено(Объект.Ссылка) И Объект.ТипПодключения = Перечисления.ТипПодключенияКластер1С.АгентКИП Тогда
        АгентОперативныйРежим(Объект.Ссылка, Истина);
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    УстановитьВидимостьТипПодключения();
    ЗаполнитьПредставлениеСерверRAS();
    
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
    
    Если ТекущийОбъект.ТипПодключения = Перечисления.ТипПодключенияКластер1С.АгентКИП Тогда
        ПортыRAS = ПрочитатьПортRAS(ТекущийОбъект);
        ПараметрыЗаписи.Вставить("ПортыRAS", ПортыRAS);
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
    
    Если ТекущийОбъект.ТипПодключения = Перечисления.ТипПодключенияКластер1С.АгентКИП Тогда
        ПортыБыли = ПараметрыЗаписи.ПортыRAS;
        
        Для Каждого ТекСтрока Из ТекущийОбъект.АгентКИППараметры Цикл
            
            ПортБыл = ПортыБыли[ТекСтрока.АгентКИП];
            Если ПортБыл <> ТекСтрока.ПортRAS Тогда
                КомандаИзменитьПортRAS(ТекСтрока.АгентКИП, ТекСтрока.ПортRAS);
            КонецЕсли;
                        
        КонецЦикла;
        
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    ЗаполнитьПредставлениеСерверRAS();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
    
    Если НЕ ЗавершениеРаботы Тогда
        АгентОперативныйРежим(Объект.Ссылка, Ложь);
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьНастройки(Команда)
    
    Если Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипПодключенияКластер1С.RAS") И Объект.RASПараметры.Количество() = 0 Тогда
        ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнены параметры подключения!", Объект.Ссылка, "Объект.RASПараметры");
        Возврат;
    ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипПодключенияКластер1С.АгентКИП") И Объект.АгентКИППараметры.Количество() = 0 Тогда    
        ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнены параметры подключения!", Объект.Ссылка, "Объект.АгентКИППараметры");
        Возврат;
    КонецЕсли;
    
    РезультатПроверки = ПроверитьНастройкиНаСервере();
    
    Для Каждого ТекРезультат Из РезультатПроверки Цикл
        Сообщить(ТекРезультат.Значение);
    КонецЦикла;
        
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипПодключенияПриИзменении(Элемент)
    УстановитьВидимостьТипПодключения();
КонецПроцедуры

&НаКлиенте
Процедура RASПараметрыСерверАдминистрированияПриИзменении(Элемент)
    
    ТекДанные = Элементы.RASПараметры.ТекущиеДанные;
    СерверАдминистрирования = Кластер_1СКлиентСервер.РазделитьСерверПорт(ТекДанные.СерверАдминистрирования);
    ТекДанные.АдресСервераАдминистрирования = СерверАдминистрирования.Сервер;
    ТекДанные.ПортСервераАдминистрирования = СерверАдминистрирования.Порт;
    
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    Объект.Наименование = Строка(Объект.ТипПодключения) + " (";
    
    Если Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипПодключенияКластер1С.RAS") Тогда
        Для Каждого ТекСтрока Из Объект.RASПараметры Цикл
            Объект.Наименование = Объект.Наименование + ТекСтрока.СерверАдминистрирования + ", ";
        КонецЦикла;
    ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипПодключенияКластер1С.АгентКИП") Тогда
        Для Каждого ТекСтрока Из Объект.АгентКИППараметры Цикл
            Объект.Наименование = Объект.Наименование + ТекСтрока.АгентКИП + ":" + Формат(ТекСтрока.ПортRAS, "ЧН=0; ЧГ=0") + ", ";
        КонецЦикла;
    КонецЕсли;
    
    Объект.Наименование = Лев(Объект.Наименование, СтрДлина(Объект.Наименование) - 2);
    Объект.Наименование = Объект.Наименование + ")";
        
КонецПроцедуры

&НаКлиенте
Процедура АгентКИППараметрыАктивныйПриИзменении(Элемент)
    
    Для Каждого ТекСтрока Из Объект.АгентКИППараметры Цикл
        ТекСтрока.Активный = Ложь;
    КонецЦикла;
    
    Элементы.АгентКИППараметры.ТекущиеДанные.Активный = Истина;
            
КонецПроцедуры

&НаКлиенте
Процедура АгентКИППараметрыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
    
    ТекущиеДанные = Элемент.ТекущиеДанные;
    
    Если Объект.АгентКИППараметры.Количество() = 1 Тогда
        
        ТекущиеДанные.Активный = Истина;
        
    ИначеЕсли ТекущиеДанные <> Неопределено И Элемент.ТекущийЭлемент.Имя = "АгентКИППараметрыАктивный" Тогда
        
        Если НоваяСтрока И Копирование Тогда
            ТекущиеДанные.Активный = Ложь;
        КонецЕсли;
        
        ЕстьАктивный = Ложь;
        Для Каждого ТекСтрока Из Объект.RASПараметры Цикл
            ЕстьАктивный = ЕстьАктивный ИЛИ ТекСтрока.Активный;
        КонецЦикла;
        
        ТекущиеДанные.Активный = НЕ ЕстьАктивный;
        
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура RASПараметрыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
    
    ТекущиеДанные = Элемент.ТекущиеДанные;
    
    Если Объект.RASПараметры.Количество() = 1 Тогда
        
        ТекущиеДанные.Активный = Истина;
        
    ИначеЕсли ТекущиеДанные <> Неопределено И Элемент.ТекущийЭлемент.Имя = "RASПараметрыАктивный" Тогда
        
        Если НоваяСтрока И Копирование Тогда
            ТекущиеДанные.Активный = Ложь;
        КонецЕсли;
        
        ЕстьАктивный = Ложь;
        Для Каждого ТекСтрока Из Объект.RASПараметры Цикл
            ЕстьАктивный = ЕстьАктивный ИЛИ ТекСтрока.Активный;
        КонецЦикла;
        
        ТекущиеДанные.Активный = НЕ ЕстьАктивный;
        
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьТипПодключения()
    
    Если Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипПодключенияКластер1С.RAS") Тогда
        Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаRAS;
    ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипПодключенияКластер1С.АгентКИП") Тогда
        Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАгентКИП;
    ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипПодключенияКластер1С.COM") Тогда
        Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаCOM;
    КонецЕсли;
        
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставлениеСерверRAS()
    
    Для Каждого ТекСтрока Из Объект.RASПараметры Цикл
        ТекСтрока.СерверАдминистрирования = ТекСтрока.АдресСервераАдминистрирования + ":" + Формат(ТекСтрока.ПортСервераАдминистрирования, "ЧН=0; ЧГ=0");
    КонецЦикла;
        
КонецПроцедуры

&НаСервере
Функция ПроверитьНастройкиНаСервере()
    
    Если Объект.ТипПодключения = Перечисления.ТипПодключенияКластер1С.RAS Тогда
        Возврат ПроверитьНастройкиНаСервереRAS();
    ИначеЕсли Объект.ТипПодключения = Перечисления.ТипПодключенияКластер1С.АгентКИП Тогда
        Возврат ПроверитьНастройкиНаСервереАгентКИП();
    КонецЕсли;
    
КонецФункции

&НаСервере
Функция ПроверитьНастройкиНаСервереRAS()
    
    РезультатПроверки = Новый СписокЗначений;
    
    Для Каждого ТекПодключение Из Объект.RASПараметры Цикл
        
        Попытка
            АдминистрированиеСервера = АдминистрированиеКластераRAS.АдминистрированиеСервера(ТекПодключение.АдресСервераАдминистрирования, ТекПодключение.ПортСервераАдминистрирования);
            РезультатПроверки.Добавить(ТекПодключение.СерверАдминистрирования + ". Успешно");
        Исключение
            РезультатПроверки.Добавить(ТекПодключение.СерверАдминистрирования + ". " + ИнформацияОбОшибке().Описание);
        КонецПопытки;
        
    КонецЦикла;
    
    Возврат РезультатПроверки;
        
КонецФункции

&НаСервере
Функция ПроверитьНастройкиНаСервереАгентКИП()
    
    РезультатПроверки = Новый СписокЗначений;
    
    Попытка
        Кластер_1С.ПроверитьПодключение(Объект.Ссылка);
        РезультатПроверки.Добавить("Успешно.");
    Исключение
        РезультатПроверки.Добавить(ИнформацияОбОшибке().Описание);
    КонецПопытки;
    
    Возврат  РезультатПроверки;
    
КонецФункции

&НаСервереБезКонтекста
Функция АгентОперативныйРежим(Ссылка, ОперативныйРежим)
    
    Если Ссылка.ТипПодключения = Перечисления.ТипПодключенияКластер1С.АгентКИП Тогда
        
        Оборудование = Справочники.Оборудование.ПустаяСсылка();
        
        АгентКИП = Справочники.ПараметрыПодключенияКластер1С.АктивноеПодключение(Ссылка);
        Если ЗначениеЗаполнено(АгентКИП) Тогда
            Оборудование = Справочники.Оборудование.НайтиПоАгенту(АгентКИП);
        КонецЕсли;
        
        Если Оборудование <> Справочники.Оборудование.ПустаяСсылка() Тогда
            
            Если ОперативныйРежим Тогда
                Настройки = РегистрыСведений.ОборудованиеОперативныеНастройки.ПрочитатьНастройки(Оборудование);
                Настройки.ДатаЗаписиUTC = ТекущаяУниверсальнаяДата();
                Настройки.ОперативныйРежим = Истина;
                РегистрыСведений.ОборудованиеОперативныеНастройки.ЗаписатьНастройки(Оборудование, Настройки);
            Иначе
                РегистрыСведений.ОборудованиеОперативныеНастройки.ОчиститьНастройки(Оборудование);
            КонецЕсли;
            
        КонецЕсли;
        
    КонецЕсли;
    
КонецФункции

&НаСервере
Функция ПрочитатьПортRAS(ТекущийОбъект)
    
    ПортыRAS = Новый Соответствие;
    
    Запрос = Новый Запрос;
    
    Запрос.Текст = "
    |ВЫБРАТЬ
    |   АгентКИП,
    |   ПортRAS
    |ИЗ
    |   Справочник.ПараметрыПодключенияКластер1С.АгентКИППараметры
    |ГДЕ
    |   Ссылка = &Ссылка
    |";
    
    Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
    
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    Пока Выборка.Следующий() Цикл
        ПортыRAS.Вставить(Выборка.АгентКИП, Выборка.ПортRAS);
    КонецЦикла;
    
    Возврат ПортыRAS;
    
КонецФункции

&НаСервере
Процедура КомандаИзменитьПортRAS(АгентКИП, ПортRAS)
    
    Команда = Новый Соответствие;
    Команда.Вставить("cluster",  "00000000-0000-0000-0000-000000000000");
    Команда.Вставить("setPortRas", ПортRAS);
    
    РегистрыСведений.КомандыАгентаКИП.ДобавитьКоманду(АгентКИП, Перечисления.ТипыКомандАгентаКИП.Cluster1C, Команда);
            
КонецПроцедуры

#КонецОбласти
