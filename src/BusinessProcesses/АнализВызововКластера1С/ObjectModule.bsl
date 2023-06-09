#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Общие настройки
Перем ТекстОшибки;
Перем ЗадачаОшибкаПриАнализе;
Перем ОбязательныеНастройки;
Перем НетПроблем;
Перем ИмяСтраницыСправки;

// Настройки контрольной процедуры

Перем КаталогНастроекТЖ;
Перем КаталогТЖСетевой;
Перем КаталогВременныхФайлов;

//////////////////////
// Общие функции
//////////////////////



Процедура ПроверкаНаНаличиеОшибокВыполнения(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = ТекстОшибки <> Неопределено;
КонецПроцедуры

Процедура КонтрольнаяПроцедураЗавершенаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = НЕ КонтрольнаяПроцедура.Выполнять;
КонецПроцедуры

//////////////////
// Разбор Настроек
//////////////////

Процедура ЕстьНезаполненныеНастройкиПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Ошибки = Новый Массив;
	Для Каждого Настройка Из ОбязательныеНастройки Цикл		
		Если НЕ ЗначениеЗаполнено(Настройка.Значение) Тогда
			Ошибки.Добавить(Настройка.Ключ);
		КонецЕсли;
	КонецЦикла;	
	Если Ошибки.Количество() > 0 Тогда
		ТекстОшибки = "Для контролируемого рабочего сервера требуется указать следующие настройки: "; 	
		ТекстОшибки = ТекстОшибки + Символы.ПС + " - " + ОбщийКлиентСервер.ОбъединитьСтроку(Ошибки, Символы.ПС + " - ");
		Результат = Истина;
		ИмяСтраницыСправки = "НеЗаполненыНастройкиВОбъектеКонтроля";

	Иначе	
		Результат = Ложь;
	КонецЕсли;
		
КонецПроцедуры

Процедура РазобратьНастройкиОбработка(ТочкаМаршрутаБизнесПроцесса)
	ТекстОшибки = Неопределено;
	Попытка
		РазобратьНастройки();
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ИмяСтраницыСправки = "НеизвестнаяОшибка";
		Отладка.Ошибка(ТекстОшибки);
		
	КонецПопытки;
КонецПроцедуры

Процедура РазобратьНастройки()
	
	ОбязательныеНастройки = Новый Соответствие;
	
	НастройкиСловарь = РегистрыСведений.ПараметрыРабочихСерверов.Получить(
		Новый Структура("ОбъектКонтроля", КонтрольнаяПроцедура.ОбъектКонтроля)
	);
	
	КаталогНастроекТЖ = НастройкиСловарь.КаталогНастроекТЖ;
	ОбязательныеНастройки.Вставить("имя каталога файла настройки технологического журнала (logcfg.xml)", КаталогНастроекТЖ);
	
	Кластер = НастройкиСловарь.Кластер;
	ОбязательныеНастройки.Вставить("кластер 1С рабочего сервера", Кластер);
	
	ЧастныеНастройкиСловарь = РегистрыСведений.НастройкиАнализВызововКластера1С.Получить(
		Новый Структура("КонтрольнаяПроцедура", КонтрольнаяПроцедура)
	);
	КаталогТЖСетевой = ЧастныеНастройкиСловарь.КаталогТЖСетевой;
	КаталогВременныхФайлов = ЧастныеНастройкиСловарь.КаталогВременныхФайлов;
	
КонецПроцедуры

/////////////////////
// Формирование задач
/////////////////////

Функция СоздатьЗадачуОтветственномуЗаВыполнение(ТекстПоручения)
	
	Возврат Неопределено;
	
КонецФункции	


////////////////////////
// Анализ
////////////////////////

Процедура ВыполнитьАнализОбработка(ТочкаМаршрутаБизнесПроцесса)
	ТекстОшибки = Неопределено;
	Попытка 
		ВыполнитьАнализ();
	Исключение
		
		НетПроблем = Неопределено;
		ИмяСтраницыСправки = "НеизвестнаяОшибка";
		Сообщение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Отладка.Ошибка(Сообщение);
		СоздатьЗадачуОтветственномуЗаВыполнение(Сообщение);
		
	КонецПопытки;

КонецПроцедуры	

Процедура ВыполнитьАнализ()
	
	НастроитьСобытияПоТехнологическомуЖурналу();
	ПрочитатьТехнологическийЖурнал();
	
КонецПроцедуры

////////////////////////
// Вспомогательные Функции
////////////////////////

Процедура НастроитьСобытияПоТехнологическомуЖурналу()
	Параметры = Новый Структура;
	Параметры.Вставить("АнализВызововКластера1С", Новый Массив);
	
	ТехнологическийЖурнал.ОбновитьФайлНастроекТехнологическогоЖурнала(КонтрольнаяПроцедура.ОбъектКонтроля, Новый Структура("КодыКонтрольныхПроцедур",Параметры));
	НетПроблем = Истина;
КонецПроцедуры

Процедура ПрочитатьТехнологическийЖурнал()
	
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
		ПараметрыИмпорта.Добавить(Общий.УникальныйКаталогДляКонтрольнойПроцедуры(КонтрольнаяПроцедура, КаталогТЖСетевой));
		ПараметрыИмпорта.Добавить(Ложь);
		ПараметрыИмпорта.Добавить(КаталогВременныхФайлов);
		
		Наименование = "Импорт техжурнала " + КонтрольнаяПроцедура;
		ФоновыеЗадания.Выполнить("ИмпортТехжурнала.ИмпортироватьТехЖурнал", ПараметрыИмпорта, КлючФоновогоЗадания, Наименование);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли








