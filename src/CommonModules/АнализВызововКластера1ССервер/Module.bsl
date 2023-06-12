////////////////////////////////////////////////////////////////////////////////
// Серверные методы, используемые на сервере при работе анализа вызовов кластера 1С
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС


Процедура ВыполнитьАнализ(КонтрольнаяПроцедура) Экспорт
    
    Настройки = РегистрыСведений.ПараметрыРабочихСерверов.Получить(Новый Структура("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля));
	ЧастныеНастройкиСловарь = РегистрыСведений.НастройкиАнализВызововКластера1С.Получить(Новый Структура("КонтрольнаяПроцедура", КонтрольнаяПроцедура));
    
    Настройки.Вставить("КаталогТЖСетевой", ЧастныеНастройкиСловарь.КаталогТЖСетевой);
	Настройки.Вставить("КаталогВременныхФайлов", ЧастныеНастройкиСловарь.КаталогВременныхФайлов);
    
	НастроитьСобытияПоТехнологическомуЖурналу(КонтрольнаяПроцедура);
	ПрочитатьТехнологическийЖурнал(КонтрольнаяПроцедура, Настройки);
	
КонецПроцедуры

Процедура НастроитьСобытияПоТехнологическомуЖурналу(КонтрольнаяПроцедура)
	Параметры = Новый Структура;
	Параметры.Вставить("АнализВызововКластера1С", Новый Массив);
	
	ТехнологическийЖурнал.ОбновитьФайлНастроекТехнологическогоЖурнала(КонтрольнаяПроцедура.ОбъектКонтроля, Новый Структура("КодыКонтрольныхПроцедур",Параметры));
	НетПроблем = Истина;
КонецПроцедуры

Процедура ПрочитатьТехнологическийЖурнал(КонтрольнаяПроцедура, Настройки)
	
	КлючФоновогоЗадания = "АнализВызововКластера1С__КлючЗаданияИмпортаЖурнала__%ИдентификаторПроцедуры";
	ИдентификаторПроцедуры = Строка(КонтрольнаяПроцедура.УникальныйИдентификатор());
	КлючФоновогоЗадания = СтрЗаменить(КлючФоновогоЗадания, "%ИдентификаторПроцедуры", ИдентификаторПроцедуры);
	
	ЗаданияПоРазборуЖурналаВФоне = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура(
		"Ключ, Состояние",
		КлючФоновогоЗадания, СостояниеФоновогоЗадания.Активно
		
	));
	Если ЗаданияПоРазборуЖурналаВФоне.Количество() > 0 Тогда
		Отладка.Информация("Разбор технологического журнала еще не окончен!");
	Иначе
		ПараметрыИмпорта = Новый Массив;
		ПараметрыИмпорта.Добавить(КонтрольнаяПроцедура);
		ПараметрыИмпорта.Добавить(Общий.УникальныйКаталогДляКонтрольнойПроцедуры(КонтрольнаяПроцедура, Настройки.КаталогТЖСетевой));
		ПараметрыИмпорта.Добавить(Ложь);
		ПараметрыИмпорта.Добавить(Настройки.КаталогВременныхФайлов);
		
		Наименование = "Импорт техжурнала " + КонтрольнаяПроцедура;
		ФоновыеЗадания.Выполнить("ИмпортТехжурнала.ИмпортироватьТехЖурнал", ПараметрыИмпорта, КлючФоновогоЗадания, Наименование);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОбновлении() Экспорт
	
КонецПроцедуры

// Включить генерацию дампов при аварийном завершении.
// Параметры - Тип Структура с полями Сетевой, Локальный, Конфигурация, УровеньДетализацииДампов
//
Функция НастроитьТЖ(Параметры) Экспорт
	
	Данные = ТехнологическийЖурнал.КонфигурацияАнализаВызововКластера1С(Параметры);
	
	Если ТехнологическийЖурнал.НужнаЗаменаТЖ(Данные, Параметры.Конфигурация, Параметры.ЛокальныйУникальный) Тогда 
		Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Комментарий = Комментарий + "
		|Повреждена секция технологического журнала в каталоге " + Параметры.Конфигурация + " по контрольной процедуре 'Анализ вызовов кластера 1С'";
		
		ЗаписьЖурналаРегистрации(
		"Поврежден ТЖ",
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		Комментарий);		
		
		locations = Новый Соответствие;
		Если Параметры.Свойство("ПеремещенияЛогов") Тогда
			locations.Вставить("log", Параметры["ЛокальныйУникальный"]);
		Иначе
			locations.Вставить("log", Параметры["Локальный"]);
		КонецЕсли;
		
		НастройкиТЖ = Новый Массив;
		НастройкиТЖ.Добавить(Параметры);
		
		// сначала удаляем старые настройки
		locations = Новый Соответствие;
		locations.Вставить("log", Параметры["ЛокальныйУникальный"]);
		ТехнологическийЖурнал.ОтключитьТехнологическийЖурнал(Параметры.Конфигурация, locations, Параметры);
		
		// а только потом пишем новые
		Описатель = ТехнологическийЖурнал.ВключитьТехнологическийЖурнал(Данные, НастройкиТЖ);
		
		Если Параметры.Свойство("ОтключениеТЖ") Тогда
			Если Параметры["ОтключениеТЖ"] Тогда
				locations = Новый Соответствие;
				locations.Вставить("log", Параметры["ЛокальныйУникальный"]);
				ТехнологическийЖурнал.ОтключитьТехнологическийЖурнал(Параметры.Конфигурация, locations, Параметры);
			КонецЕсли;
		КонецЕсли;
		
		Возврат Описатель;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтключениеТЖ") Тогда
		Если Параметры["ОтключениеТЖ"] Тогда
			locations = Новый Соответствие;
			locations.Вставить("log", Параметры["ЛокальныйУникальный"]);
			ТехнологическийЖурнал.ОтключитьТехнологическийЖурнал(Параметры.Конфигурация, locations, Параметры);
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

