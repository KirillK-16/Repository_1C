#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	ОбновитьДеревоСценарияСВопросом();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоСценарияСВопросом()	
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчистка", ЭтаФорма, Параметры);
	ПоказатьВопрос(Оповещение, НСтр("ru='Ранее заполненные параметры будут очищены. Продолжить выполнение операции?';"
    + " en = 'Do you want to continue?'"), Режим, 0);
КонецПроцедуры	

&НаСервере
Функция СформироватьНаименованиеНаСервере()
	СпрОбъект = РеквизитФормыВЗначение("Объект");
	Возврат СпрОбъект.СформироватьНаименованиеНаСервере();
КонецФункции	

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ОчиститьСообщения(); 
	
	ЗаписатьТаблицуОбъектовПривязки();
	ВыполнитьПередЗаписьюНаСервере(Отказ);	
	
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТаблицуОбъектовПривязки()
	СпрОбъект = РеквизитФормыВЗначение("Объект");
	СпрОбъект.ЗаписатьТаблицуОбъектовПривязки(ОбъектыЗаполненияПараметров);
//	НЗ = РегистрыСведений.ШаблоныЗаполненияПараметровСценариев.СоздатьНаборЗаписей();
//	НЗ.Отбор.ЭкземплярСценария.Установить(ЭкземплярСценария);
//	Для каждого Строка Из ОбъектыЗаполненияПараметров Цикл
//		НоваяЗапись = НЗ.Добавить();
//		ЗаполнитьЗначенияСвойств(НоваяЗапись, Строка);
//		НоваяЗапись.ЭкземплярСценария = ЭкземплярСценария;
//		НоваяЗапись.Объект = Новый ХранилищеЗначения(Строка.Объект);
//		НоваяЗапись.УчаствуетВИнтерфейсныхГруппировках = ?(Строка.УчаствуетВИнтерфейсныхГруппировках=0, ЛОЖЬ, ИСТИНА);
//	КонецЦикла;
//	НЗ.Записать();
КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьДанныеСценария(Команда)
	ОбновитьДеревоСценарияСВопросом();	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Параметры.Свойство("Начало", Объект.ПлановаяДатаЗапуска);
		Параметры.Свойство("Окончание", Объект.ПлановаяДатаОкончания);
	КонецЕсли;	
	
	ВосстановитьТаблицуОбъектовЗаполнения();
	ВосстановитьДеревоИзДанныхСценария();
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьТаблицуОбъектовЗаполнения()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ШаблоныЗаполненияПараметровСценариев.ЭкземплярСценария КАК ЭкземплярСценария,
	                      |	ШаблоныЗаполненияПараметровСценариев.ИмяШаблона КАК ИмяШаблона,
	                      |	ШаблоныЗаполненияПараметровСценариев.ОтносительнаяСсылкаНаМетаданные КАК ОтносительнаяСсылкаНаМетаданные,
	                      |	ШаблоныЗаполненияПараметровСценариев.Объект КАК Объект,
	                      |	ШаблоныЗаполненияПараметровСценариев.СпособЗаполнения КАК СпособЗаполнения,
	                      |	ШаблоныЗаполненияПараметровСценариев.Значение КАК Значение,
	                      |	ВЫБОР
	                      |		КОГДА ШаблоныЗаполненияПараметровСценариев.УчаствуетВИнтерфейсныхГруппировках
	                      |			ТОГДА 1
	                      |		ИНАЧЕ 0
	                      |	КОНЕЦ КАК УчаствуетВИнтерфейсныхГруппировках
	                      |ИЗ
	                      |	РегистрСведений.ШаблоныЗаполненияПараметровСценариев КАК ШаблоныЗаполненияПараметровСценариев
	                      |ГДЕ
	                      |	ШаблоныЗаполненияПараметровСценариев.ЭкземплярСценария = &ЭкземплярСценария
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ИмяШаблона");
	Запрос.УстановитьПараметр("ЭкземплярСценария", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	КолВо = ОбъектыЗаполненияПараметров.Количество();
	Для й = 1 По КолВо Цикл
		НайденныйЭлемент = РезультатЗапроса.НайтиСтроки(Новый Структура("ИмяШаблона, ОтносительнаяСсылкаНаМетаданные", ОбъектыЗаполненияПараметров[0].ИмяШаблона, ОбъектыЗаполненияПараметров[0].ОтносительнаяСсылкаНаМетаданные));
		Если НайденныйЭлемент.Количество() <> 0 Тогда
			РезультатЗапроса.Удалить(НайденныйЭлемент[0]);
		КонецЕсли;	
	КонецЦикла;
	
	Для Каждого Строка Из РезультатЗапроса Цикл
		НоваяСтрока = ОбъектыЗаполненияПараметров.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.Объект = Строка.Объект.Получить();

		Если НоваяСтрока.Объект = Неопределено И (НоваяСтрока.СпособЗаполнения = Перечисления.СпособыЗаполненияПараметровКоманды.РучнойВвод Или НоваяСтрока.СпособЗаполнения = Перечисления.СпособыЗаполненияПараметровКоманды.ПустаяСтрока) Тогда
			НоваяСтрока.Объект = НоваяСтрока.Значение; 
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	

&НаСервере
Процедура ВосстановитьДеревоИзДанныхСценария()
	Прочитать();
	СпрОбъект = РеквизитФормыВЗначение("Объект");	
	Дерево =  СпрОбъект.ПодготовитьДеревоСценария();

	ТаблицаШагов = РаботаСоСценариямиАвтоматизацииСервер.ВыбратьДанныеШаговАвтоматизации(Объект);
	РаботаСоСценариямиАвтоматизацииСервер.ВизуализацияДерева(ТаблицаШагов, Дерево);
	
	Дерево.Колонки.Удалить("НомерШага");
	
	// получим все параметры
	Для Каждого Шаг Из ТаблицаШагов Цикл
		Если Шаг.ТипШага = Перечисления.ТипыЭлементовСхемыСценария.Шаг Тогда
			ОбновитьПараметрыСценарияНаСервере(Шаг.ИдентификаторШага);
			Если ЗначениеЗаполнено(Шаг.ИдентификаторШагаОтката) Тогда
				ОбновитьПараметрыСценарияНаСервере(Шаг.ИдентификаторШагаОтката);
			КонецЕсли;	
		КонецЕсли;
    КонецЦикла;
	
	ЗначениеВДанныеФормы(Дерево, ДеревоСценария);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОчистка(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьЭкземплярНаСервере();
		Прочитать();
		
		ЗаполнитьСписокВыбораШаблоновПараметров();
		
		ОбъектыЗаполненияПараметров.Очистить();
		ПараметрыШаговАвтоматизации.Очистить();
		
		ВосстановитьТаблицуОбъектовЗаполнения();
		ВосстановитьДеревоИзДанныхСценария();
				
		Отбор = Новый Структура("ИдентификаторШага", ПредопределенноеЗначение("Справочник.ШагиАвтоматизации.ПустаяСсылка"));
		Элементы.ПараметрыШаговАвтоматизации.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
		
		ЭлементыДерева = ДеревоСценария.ПолучитьЭлементы();
		Если ЭлементыДерева.Количество() > 0 Тогда
			Элементы.ДеревоСценария.Развернуть(ЭлементыДерева[0].ПолучитьИдентификатор(), Истина);
		КонецЕсли;	

	Иначе
		Возврат;
    КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭкземплярНаСервере()
	СпрОбъект = РеквизитФормыВЗначение("Объект");
	
	Если СпрОбъект.ЭтоНовый() Тогда 
		СсылкаНового = СпрОбъект.ПолучитьСсылкуНового();
		Если СсылкаНового.Пустая() Тогда
			СсылкаНового = Справочники.ЭкземплярыСценариевАвтоматизации.ПолучитьСсылку(Новый УникальныйИдентификатор);
			СпрОбъект.УстановитьСсылкуНового(СсылкаНового);
		КонецЕсли;	
	КонецЕсли;	
	
	НачатьТранзакцию();
	Попытка
		СпрОбъект.ЗаполнитьЭкземплярНаСервере();
		СпрОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
	КонецПопытки;	
	
	ЗначениеВРеквизитФормы(СпрОбъект, "Объект");
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыСценарияНаСервере(ИдентификаторШага)
	ПараметрыШагов = РаботаСоСценариямиАвтоматизацииСервер.ПолучитьПараметрыСценарияНаСервере(ИдентификаторШага);

	Для каждого Строка Из ПараметрыШагов Цикл
		СтрокиКоллекции = ПараметрыШаговАвтоматизации.НайтиСтроки(Новый Структура("ИдентификаторШага, Параметр", ИдентификаторШага, Строка.Параметр));
		Если СтрокиКоллекции.Количество() = 0 Тогда
			НоваяСтрокаКоллекции = ПараметрыШаговАвтоматизации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаКоллекции, Строка);
			
			Если Не ПустаяСтрока(Строка.ШаблонЗаполнения) Тогда
				НоваяСтрокаКоллекции.Значение = Строка.ШаблонЗаполнения;
				НоваяСтрокаКоллекции.ИзШаблона = Истина;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;	
	ПараметрыШаговАвтоматизации.Сортировать("Обязательный, Параметр");
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСценарияПриАктивизацииСтроки(Элемент)
	ВидимостьДоступностьПараметровПриАктивизации();
	ОбновитьПараметрыСценария(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыСценария(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Идентификатор = ?(НЕ ОтобразитьПараметрыОтката, Элемент.ТекущиеДанные.ИдентификаторШага, Элемент.ТекущиеДанные.ИдентификаторШагаОтката);
		Отбор = Новый Структура("ИдентификаторШага, ИзШаблона", Идентификатор, Ложь);
		//Если (Элемент.ТекущиеДанные.ТипШага = ПредопределенноеЗначение("Перечисление.ТипыЭлементовСхемыСценария.Шаг")
		//		ИЛИ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ИдентификаторШагаОтката))
		//	И ПараметрыШаговАвтоматизации.НайтиСтроки(Отбор).Количество() = 0
		//	И ЗначениеЗаполнено(Идентификатор) Тогда
		//		ОбновитьПараметрыСценарияНаСервере(Идентификатор);
		//КонецЕсли;
		Элементы.ПараметрыШаговАвтоматизации.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ИдентификаторШага", Идентификатор));
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ПараметрыШаговАвтоматизацииЗначениеПриИзменении(Элемент)
	ТекДанные = Элементы.ПараметрыШаговАвтоматизации.ТекущиеДанные;
	ПриИзмененииИсточникаЗначенияПараметра(ТекДанные);	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИсточникаЗначенияПараметра(ТекДанные)
	Если ТекДанные <> Неопределено Тогда
		Модифицированность = Истина;
		ТекДанные.ЗаполненоРанее = Ложь;
		ТекДанные.ПоУмолчанию = Ложь;
		СтрокиШаблонаЗаполнения = ОбъектыЗаполненияПараметров.НайтиСтроки(Новый Структура("ИмяШаблона", ВРег(ТекДанные.Значение)));
		Если СтрокиШаблонаЗаполнения.Количество() >0 Тогда
			ТекДанные.Значение = ВРег(ТекДанные.Значение);
			ТекДанные.РеальноеЗначение = СтрокиШаблонаЗаполнения[0].Значение;
			ТекДанные.ИзШаблона = Истина
		Иначе
			ТекДанные.РеальноеЗначение = ТекДанные.Значение;
			ТекДанные.ИзШаблона = Ложь;
		КонецЕсли;	
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ВладелецОчистка(Элемент, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ОбновитьДеревоСценарияСВопросом();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСценарияИспользоватьПриИзменении(Элемент)
	РаботаСоСценариямиАвтоматизацииКлиент.ДеревоФлагПриИзменении(Элемент, "Использовать");
	Если НЕ Элементы.ДеревоСценария.ТекущиеДанные.Использовать Тогда
		Элементы.ДеревоСценария.ТекущиеДанные.ИспользоватьОткат = Ложь;
		РаботаСоСценариямиАвтоматизацииКлиент.ДеревоФлагПриИзменении(Элемент, "ИспользоватьОткат");
	КонецЕсли;	
	ВидимостьДоступностьПараметровПриАктивизации();	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьДоступностьПараметровПриАктивизации()
	Если Элементы.ДеревоСценария.ТекущиеДанные <> Неопределено Тогда
		Если НЕ Элементы.ДеревоСценария.ТекущиеДанные.Использовать ИЛИ Не ЗначениеЗаполнено(Элементы.ДеревоСценария.ТекущиеДанные.ИдентификаторШагаОтката) Тогда
			ОтобразитьПараметрыОтката = Ложь;
			Элементы.ОтобразитьПараметрыОтката.Доступность = Ложь;
		Иначе
			Элементы.ОтобразитьПараметрыОтката.Доступность = Истина;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ДеревоСценарияВремяНачалаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПередЗаписьюНаСервере(Отказ=Ложь)
	СпрОбъект = РеквизитФормыВЗначение("Объект");
	Объект.Наименование = СформироватьНаименованиеНаСервере();
	Объект.ДатаИзменения = РаботаСоСценариямиАвтоматизацииСервер.ПолучитьТекущуюДатуСеанса();
	Дерево = РеквизитФормыВЗначение("ДеревоСценария");
	Успех = ЗаписатьШагиКоллекцииСтрок(Дерево.Строки);
	Если Успех Тогда
		ЗаписатьПараметрыШаговАвтоматизации();
	Иначе
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьПараметрыШаговАвтоматизации()
	ПараметрыШагов = РеквизитФормыВЗначение("ПараметрыШаговАвтоматизации");
	
	Для Каждого Строка Из ПараметрыШагов Цикл
		Если Не Строка.ЗаполненоРанее Или Строка.ИзШаблона Тогда
			РаботаСоСценариямиАвтоматизацииСервер.ВыполнитьАктуализациюПараметра(Строка, ОбъектыЗаполненияПараметров.Выгрузить());
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ЗаписатьШагиКоллекцииСтрок(СтрокиДереваШагов, Итератор = -1, Родитель = Неопределено)
	Успех = Истина;
	Если Родитель = Неопределено Тогда
		Родитель = Справочники.ШагиАвтоматизации.ПустаяСсылка();
	КонецЕсли;	
	
	Для каждого Строка Из СтрокиДереваШагов Цикл
		Если Успех Тогда
			Итератор = Итератор + 1;
			Успех = ЗаполнитьШаг(Строка.ИдентификаторШага, Родитель, Итератор, Строка, Объект.СопоставлениеШаблоновОборудования);
			
			// обработаем шаг отката
			Если Успех И Не Строка.ИдентификаторШагаОтката.Пустая() Тогда
				Успех = ЗаполнитьШаг(Строка.ИдентификаторШагаОтката, Родитель, Итератор, Строка, Объект.СопоставлениеШаблоновОборудования);
			КонецЕсли;	
			
			Если Успех Тогда
				Успех = ЗаписатьШагиКоллекцииСтрок(Строка.Строки, Итератор, Строка.ИдентификаторШага);
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
	Возврат Успех;
КонецФункции

&НаСервереБезКонтекста
Функция ЗаполнитьШаг(ИдентификаторШага, Родитель, Итератор, СтрокаДерева, СопоставлениеШаблоновОборудования)
	Успех = Истина;
	
	ШагСценария = ИдентификаторШага.ПолучитьОбъект();
			
	Если ШагСценария.Родитель <> Родитель Тогда
		ШагСценария.Родитель = Родитель;
	КонецЕсли;
	
	Если ШагСценария.Код <> Итератор Тогда
		ШагСценария.Код = Итератор;
	КонецЕсли;
	
	Если ШагСценария.ВремяНачала <> СтрокаДерева.ВремяНачала Тогда
		ШагСценария.ВремяНачала = СтрокаДерева.ВремяНачала;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ШагСценария.ОткатываемыйШаг) Тогда
		Если ШагСценария.Использовать <> СтрокаДерева.Использовать Тогда
			ШагСценария.Использовать = СтрокаДерева.Использовать;
		КонецЕсли; 
	Иначе
		Если ШагСценария.Использовать <> (СтрокаДерева.Использовать И СтрокаДерева.ИспользоватьОткат) Тогда
			ШагСценария.Использовать = (СтрокаДерева.Использовать И СтрокаДерева.ИспользоватьОткат);
		КонецЕсли; 
	КонецЕсли;	
	
	Если ШагСценария.ШаблонОборудования <> СтрокаДерева.ШаблонЕдиницыОборудования Тогда
		ШагСценария.ШаблонОборудования = СтрокаДерева.ШаблонЕдиницыОборудования;
	КонецЕсли;
	
	Оборудование = СопоставлениеШаблоновОборудования.НайтиСтроки(Новый Структура("Шаблон", СтрокаДерева.ШаблонЕдиницыОборудования)); 
	Если Оборудование.Количество() = 1 Тогда
		Если ШагСценария.Оборудование <> Оборудование[0].РеальноеЗначение Тогда
			ШагСценария.Оборудование = Оборудование[0].РеальноеЗначение;
		КонецЕсли;
	ИначеЕсли ШагСценария.ТипШага = Перечисления.ТипыЭлементовСхемыСценария.Шаг Тогда	
		Успех = Ложь;
		ЗаписьЖурналаРегистрации(НСтр("ru='Запись шагов'", Метаданные.ОсновнойЯзык.КодЯзыка), УровеньЖурналаРегистрации.Ошибка,,, НСтр("ru='Не удалось установить оборудование для исполнения'"));
	КонецЕсли;	
	
	Если Успех И ШагСценария.Модифицированность() Тогда
		Попытка
			ШагСценария.Записать();
		Исключение
			Успех = Ложь;
			ЗаписьЖурналаРегистрации(НСтр("ru='Запись шагов'", Метаданные.ОсновнойЯзык.КодЯзыка), УровеньЖурналаРегистрации.Ошибка,,, "Не удалось записать шаг по причине: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;	
	КонецЕсли;
	
	Возврат Успех;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)	
	Если НЕ РаботаСоСценариямиАвтоматизацииСервер.ЕстьСценарии() Тогда
		ПоказатьПредупреждение(, НСтр("ru='В базе не найдено ни одного сценария. Загрузите поставляемые сценарии или создайте новый сценарий самостоятельно'"));
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	ЗаполнитьСписокВыбораШаблоновПараметров();
	
	ЭлементыДерева = ДеревоСценария.ПолучитьЭлементы();
	Если ЭлементыДерева.Количество() > 0 Тогда
		Элементы.ДеревоСценария.Развернуть(ЭлементыДерева[0].ПолучитьИдентификатор(), Истина);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	СтруктураСостояний = РаботаСоСценариямиАвтоматизацииСервер.ПолучитьСтруктуруСостояний();
	
	СписокАктивных = СтруктураСостояний.СписокАктивных;
	СписокНеАктивных = СтруктураСостояний.СписокНеАктивных;
	СписокФинальных = СтруктураСостояний.СписокФинальных;
	СписокУспешных = СтруктураСостояний.СписокУспешных;
	СписокНеУспешных = СтруктураСостояний.СписокНеУспешных;
	
	// доступность формы
	НеМенятьФорму = (Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСценария.Запланирован")
						Или Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСценария.ЗавершенФатально")
						Или СписокАктивных.Найти(Объект.Состояние) <> Неопределено 
						Или СписокУспешных.Найти(Объект.Состояние) <> Неопределено);
	
	ТолькоПросмотр = НеМенятьФорму;
	Элементы.СопоставлениеШаблоновОбновитьДанныеСценария.Доступность = Не НеМенятьФорму;
	Элементы.ПараметрыШаговАвтоматизации.ТолькоПросмотр = НеМенятьФорму;
	Элементы.ОбъектыЗаполненияПараметров.ТолькоПросмотр = НеМенятьФорму;
	Элементы.ДеревоСценария.ТолькоПросмотр = НеМенятьФорму;
	Элементы.ГруппаСредаВыполнения.ТолькоПросмотр = НеМенятьФорму;
	
	// доступность команд
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСценария.Запланирован") 
		Или СписокАктивных.Найти(Объект.Состояние) <> Неопределено 
		Или СписокФинальных.Найти(Объект.Состояние) <> Неопределено Тогда
		
		Элементы.ФормаГруппаСтарт.Доступность = Ложь;
		Если РаботаСоСценариямиАвтоматизацииСервер.ВозможноПродолжениеНеуспешного(Объект.Ссылка) Тогда
			Элементы.ФормаПродолжитьВыполнение.Доступность = Истина;
		Иначе
			Элементы.ФормаПродолжитьВыполнение.Доступность = Ложь;
		КонецЕсли;			
			
		Если СписокАктивных.Найти(Объект.Состояние) <> Неопределено Тогда
			Элементы.ФормаПрервать.Доступность = Истина;
			Элементы.ФормаСбросить.Доступность = Ложь;
		Иначе	
			Элементы.ФормаПрервать.Доступность = Ложь;
			Элементы.ФормаСбросить.Доступность = Истина;
		КонецЕсли;	
	Иначе
		Элементы.ФормаГруппаСтарт.Доступность = Истина;
		Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСценария.НеЗапланирован") Тогда
			Элементы.ФормаПрервать.Доступность = Ложь;
			Элементы.ФормаСбросить.Доступность = Ложь;
			Элементы.ФормаПродолжитьВыполнение.Доступность = Ложь;
		Иначе	
			Элементы.ФормаПрервать.Доступность = Ложь;
			Элементы.ФормаСбросить.Доступность = Истина;
			Элементы.ФормаПродолжитьВыполнение.Доступность = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСценария.НеЗапланирован") Тогда
		Элементы.ГруппаОсновные.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ГруппаОсновные.ТолькоПросмотр = Истина;
	КонецЕсли;	
		
	Если СписокАктивных.Найти(Объект.Состояние) <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбновитьОтображениеДанныхСценария", 10);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ФормуВРежимКонтроля(КонтрольВкл)
	Если КонтрольВкл Тогда
		Элементы.ГруппаДаты.Видимость = Ложь;	
		Элементы.ГруппаПараметры.Видимость = Ложь;	
		Элементы.ГруппаШаблоныОборудования.Видимость = Ложь;	
		Элементы.ГруппаОбъектыЗаполнения.Видимость = Ложь;
		
		Элементы.ГруппаДерево.Видимость = Истина;
		
		Элементы.ДеревоСценарияИспользовать.Видимость = Ложь;
		Элементы.ДеревоСценарияИспользоватьОткат.Видимость = Ложь;
		
		РежимПротоколирования = Истина;
		
	Иначе
		Элементы.ГруппаДаты.Видимость = Истина;	
		Элементы.ГруппаПараметры.Видимость = Истина;	
		Элементы.ГруппаШаблоныОборудования.Видимость = Истина;	
		Элементы.ГруппаОбъектыЗаполнения.Видимость = Истина;
		
		Элементы.ГруппаДерево.Видимость = Истина;
		
		Элементы.ДеревоСценарияИспользовать.Видимость = Истина;
		Элементы.ДеревоСценарияИспользоватьОткат.Видимость = Истина;
		
		РежимПротоколирования = Ложь;
	КонецЕсли;	
	
	ИзменитьФормуОтображенияСценария();
	
	Если Элементы.ФормаРежимМонитора.Пометка <> КонтрольВкл Тогда
		Элементы.ФормаРежимМонитора.Пометка = КонтрольВкл;
	КонецЕсли;	
		
КонецПроцедуры	

&НаКлиенте
Процедура ПараметрыШаговАвтоматизацииПоУмолчаниюПриИзменении(Элемент)
	Модифицированность = Истина;
	Элементы.ПараметрыШаговАвтоматизации.ТекущиеДанные.Значение = "";
	Элементы.ПараметрыШаговАвтоматизации.ТекущиеДанные.РеальноеЗначение = "";
	Элементы.ПараметрыШаговАвтоматизации.ТекущиеДанные.ЗаполненоРанее = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровОбъектПриИзменении(Элемент)
	
	ТекущиеДанныеСтроки = Элементы.ОбъектыЗаполненияПараметров.ТекущиеДанные;
	Если ТекущиеДанныеСтроки <> Неопределено Тогда
		Модифицированность = Истина;
		РаботаСоСценариямиАвтоматизацииКлиент.ЗаполнитьЗначениеПараметраПоДаннымОбъекта(ТекущиеДанныеСтроки);
		РаботаСоСценариямиАвтоматизацииКлиент.ВыполнитьПересчетСоставныхПараметров(ТекущиеДанныеСтроки, ОбъектыЗаполненияПараметров);
		
		Для каждого Строка Из ОбъектыЗаполненияПараметров Цикл
			Если Строка.СпособЗаполнения = ПредопределенноеЗначение("Перечисление.СпособыЗаполненияПараметровКоманды.РучнойВвод") 
				И СтрНайти(Строка.Объект, ТекущиеДанныеСтроки.ИмяШаблона) <> 0 Тогда
				РаботаСоСценариямиАвтоматизацииКлиент.ВыполнитьПересчетСоставныхПараметров(Строка, ОбъектыЗаполненияПараметров);
			КонецЕсли;	
		КонецЦикла;	
		Для каждого Строка Из ОбъектыЗаполненияПараметров Цикл
			ПрописатьРеальноеЗначениеПараметраПоШаблону(Строка.ИмяШаблона, Строка.Значение);
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПрописатьРеальноеЗначениеПараметраПоШаблону(ИмяШаблона, РеальноеЗначениеПараметра, Удаление = Ложь)
	ПараметрыИзШаблона = ПараметрыШаговАвтоматизации.НайтиСтроки(Новый Структура("Значение, ИзШаблона", ИмяШаблона, Истина));
	Для Каждого Параметр Из ПараметрыИзШаблона Цикл
		Если Параметр.ИзШаблона Тогда
			Если Удаление Тогда
				Параметр.Значение = "";
				Параметр.РеальноеЗначение = "";
				Параметр.ИзШаблона = Ложь;
			Иначе
				Параметр.Значение = ИмяШаблона;
				Параметр.РеальноеЗначение = РеальноеЗначениеПараметра;
			КонецЕсли;	
			Параметр.ЗаполненоРанее = Ложь;
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	

&НаКлиенте
Процедура ДеревоСценарияПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗапланировать(Команда)
	ВыполнитьПередЗаписьюНаСервере();
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = НСтр("ru='Плановые даты должны быть заполнены и дата окончания должна быть больше даты начала'");
	Если Команда <> Неопределено И НЕ ЗначениеЗаполнено(Объект.ПлановаяДатаЗапуска) Тогда
		Сообщение.Поле = "Объект.ПлановаяДатаЗапуска";
		Сообщение.Сообщить();
	ИначеЕсли Команда <> Неопределено И НЕ ЗначениеЗаполнено(Объект.ПлановаяДатаОкончания) Тогда
		Сообщение.Поле = "Объект.ПлановаяДатаОкончания";
		Сообщение.Сообщить();
	ИначеЕсли Команда <> Неопределено И Объект.ПлановаяДатаЗапуска >=	Объект.ПлановаяДатаОкончания Тогда
		Сообщение.Поле = "Объект.ПлановаяДатаОкончания";
		Сообщение.Сообщить();
	Иначе	
		ИсходноеСостояние = Объект.Состояние;
		Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСценария.Запланирован");
		Попытка
			Записать(); 
			Если Команда <> Неопределено Тогда
				Закрыть();
			КонецЕсли;	
		Исключение
			Если Команда = Неопределено Тогда
				ВызватьИсключение;
			Иначе
				ПоказатьПредупреждение(, НСтр("ru='Не удалось перевести в статус ""Запланирован""'"));	
				Объект.Состояние = ИсходноеСостояние;
			КонецЕсли;	
		КонецПопытки;
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПараметрыОткатаПриИзменении(Элемент)
	ОбновитьПараметрыСценария(Элементы.ДеревоСценария);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСценарияИспользоватьОткатПриИзменении(Элемент)
	РаботаСоСценариямиАвтоматизацииКлиент.ДеревоФлагПриИзменении(Элемент, "ИспользоватьОткат");
	Если Элементы.ДеревоСценария.ТекущиеДанные.ИспользоватьОткат Тогда
		Элементы.ДеревоСценария.ТекущиеДанные.Использовать = Истина;
		РаботаСоСценариямиАвтоматизацииКлиент.ДеревоФлагПриИзменении(Элемент, "Использовать");
	КонецЕсли;	
	ВидимостьДоступностьПараметровПриАктивизации();	
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораШаблоновПараметров()
	Элементы.ПараметрыШаговАвтоматизацииЗначение.СписокВыбора.Очистить();
	й=0;
	Для каждого ЭлементКоллекции Из ОбъектыЗаполненияПараметров Цикл
		Если ЭлементКоллекции.ИмяШаблона <> "" Тогда
			Элементы.ПараметрыШаговАвтоматизацииЗначение.СписокВыбора.Вставить(й, ЭлементКоллекции.ИмяШаблона);
			й=й+1;
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровИмяШаблонаПриИзменении(Элемент)
	ТекДанные = Элементы.ОбъектыЗаполненияПараметров.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ТекДанные.ИмяШаблона = ВРег(Элементы.ОбъектыЗаполненияПараметров.ТекущиеДанные.ИмяШаблона);
		Для Каждого Параметр Из ПараметрыШаговАвтоматизации Цикл
			Если Параметр.ИзШаблона Тогда // ссылка на шаблон
				Шаблон = Параметр.Значение;
				Если ОбъектыЗаполненияПараметров.НайтиСтроки(Новый Структура("ИмяШаблона", Шаблон)).Количество()=0 Тогда
					Сообщение = Новый СообщениеПользователю;
					ТекстСообщения = "Очищен параметр " + Параметр.Параметр;
					Сообщение.Текст = НСтр("ru='" + ТекстСообщения + "'");
					Сообщение.Сообщить();
					
					Параметр.Значение = "";
					Параметр.РеальноеЗначение = "";
					Параметр.ЗаполненоРанее = Ложь;
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;	
		Для Каждого Строка Из ОбъектыЗаполненияПараметров Цикл
			РаботаСоСценариямиАвтоматизацииКлиент.ЗаполнитьЗначениеПараметраПоДаннымОбъекта(Строка);
		КонецЦикла;	
		УстановитьРежимРедактированияЗначения(ТекДанные.СпособЗаполнения); 
	КонецЕсли;	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровСпособЗаполненияПриИзменении(Элемент)
	ПриИзмененииПриродыШаблона();
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровОтносительнаяСсылкаНаМетаданныеПриИзменении(Элемент)
	ПриИзмененииПриродыШаблона();
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПриродыШаблона()
	ТекДанные = Элементы.ОбъектыЗаполненияПараметров.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		РаботаСоСценариямиАвтоматизацииКлиент.ПриИзмененииПриродыШаблона(ТекДанные, ОбъектыЗаполненияПараметров);
		УстановитьРежимРедактированияЗначения(ТекДанные.СпособЗаполнения);
		Для каждого Строка Из ОбъектыЗаполненияПараметров Цикл
			ПрописатьРеальноеЗначениеПараметраПоШаблону(Строка.ИмяШаблона, Строка.Значение);
		КонецЦикла;	
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьРежимРедактированияЗначения(СпособЗаполнения)
	РаботаСоСценариямиАвтоматизацииКлиент.УстановитьРежимРедактированияЗначения(СпособЗаполнения, Элементы.ОбъектыЗаполненияПараметровОтносительнаяСсылкаНаМетаданные, Элементы.ОбъектыЗаполненияПараметровОбъект); 
КонецПроцедуры	

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровОтносительнаяСсылкаНаМетаданныеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	РаботаСоСценариямиАвтоматизацииКлиент.ОбъектыЗаполненияПараметровОтносительнаяСсылкаНаМетаданныеНачалоВыбора(Объект.Ссылка, Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровПриИзменении(Элемент)
	ЗаполнитьСписокВыбораШаблоновПараметров();
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.ОбъектыЗаполненияПараметров.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		УстановитьРежимРедактированияЗначения(ТекДанные.СпособЗаполнения);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровПередУдалением(Элемент, Отказ)
	ПрописатьРеальноеЗначениеПараметраПоШаблону(Элемент.ТекущиеДанные.ИмяШаблона, "", Истина);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровЗначениеПриИзменении(Элемент)
	ТекДанные = Элементы.ОбъектыЗаполненияПараметров.ТекущиеДанные;
	ПрописатьРеальноеЗначениеПараметраПоШаблону(ТекДанные.ИмяШаблона, ТекДанные.Значение);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоСценария(Команда)
	ОбновитьОтображениеДанныхСценария();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеДанныхСценария()
	Если РежимПротоколирования Тогда
		ПолучитьПротокол();
	Иначе
		ОбновитьДеревоНаКлиенте();
	КонецЕсли;
	
	СписокАктивных = РаботаСоСценариямиАвтоматизацииСервер.ПолучитьАктивныеСостояния();
	Если СписокАктивных.Найти(Объект.Состояние) = Неопределено Тогда
		ФормуВРежимКонтроля(Ложь);
		ОтключитьОбработчикОжидания("ОбновитьОтображениеДанныхСценария");
	КонецЕсли;
		
	УстановитьВидимостьДоступность();	
КонецПроцедуры	


&НаКлиенте
Процедура ОбновитьДеревоНаКлиенте()
	ВосстановитьДеревоИзДанныхСценария();
	ЭлементыДерева = ДеревоСценария.ПолучитьЭлементы();
	Если ЭлементыДерева.Количество() > 0 Тогда
		Элементы.ДеревоСценария.Развернуть(ЭлементыДерева[0].ПолучитьИдентификатор(), Истина);
	КонецЕсли;
	
	Прочитать();
	
КонецПроцедуры	

&НаКлиенте
Процедура ПолучитьПротокол() 
	Прочитать();
	
	Протокол = ПолучитьПротоколНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьПротоколНаСервере()
	ТаблицаШагов = РаботаСоСценариямиАвтоматизацииСервер.ВыбратьДанныеШаговАвтоматизации(Объект);
	МакетПротокола = Справочники.ЭкземплярыСценариевАвтоматизации.ПолучитьМакет("ПротоколСценария");
	ТабДок = Новый ТабличныйДокумент;

	ОбластьОписание = МакетПротокола.ПолучитьОбласть("ЗаголовокПротокола");
	ОбластьОписание.Параметры.Описание = Объект.Владелец.Описание;
	
	Состояния = РаботаСоСценариямиАвтоматизацииСервер.ПолучитьСтруктуруСостояний();
	Если Состояния.СписокУспешных.Найти(Объект.Состояние) <> Неопределено Тогда
		ОбластьОписание.Параметры.Картинка = БиблиотекаКартинок.РукаОк;
	ИначеЕсли Состояния.СписокНеУспешных.Найти(Объект.Состояние) <> Неопределено Тогда
		ОбластьОписание.Параметры.Картинка = БиблиотекаКартинок.РукаНеОк;
	КонецЕсли;	
	ТабДок.Вывести(ОбластьОписание);
	
	ОбластьШапка = МакетПротокола.ПолучитьОбласть("Шапка");
	ТабДок.Вывести(ОбластьШапка);
	
	Для Каждого Строка Из ТаблицаШагов Цикл
		Если Строка.ТипШага = Перечисления.ТипыЭлементовСхемыСценария.Шаг 
			И Строка.Использовать Тогда
			Если Строка.СостояниеШага = Перечисления.СостоянияШаговСценария.Выполнен Тогда
				ОбластьСтрока = МакетПротокола.ПолучитьОбласть("СтрокаПротоколаОк");
			ИначеЕсли Строка.СостояниеШага = Перечисления.СостоянияШаговСценария.НеВыполнялсяВследствиеОтката 
				Или Строка.СостояниеШага = Перечисления.СостоянияШаговСценария.НеВыполнялсяВследствиеОшибки Тогда
				ОбластьСтрока = МакетПротокола.ПолучитьОбласть("СтрокаПротоколаНеВыполнялось");
			ИначеЕсли Строка.СостояниеШага = Перечисления.СостоянияШаговСценария.Выполняется Тогда
				ОбластьСтрока = МакетПротокола.ПолучитьОбласть("СтрокаПротоколаВыполняется");
			ИначеЕсли Строка.СостояниеШага = Перечисления.СостоянияШаговСценария.НеВыполнялся Тогда
				ОбластьСтрока = МакетПротокола.ПолучитьОбласть("СтрокаПротокола");
			Иначе
				ОбластьСтрока = МакетПротокола.ПолучитьОбласть("СтрокаПротоколаНеОк");
			КонецЕсли;
			
			ОбластьСтрока.Параметры.Шаг = Строка.НаименованиеШага;
			ОбластьСтрока.Параметры.Состояние = Строка.ДополнительнаяИнформация;
			ОбластьСтрока.Параметры.Роль = Строка.ШаблонЕдиницыОборудования;
			ОбластьСтрока.Параметры.Оборудование = Строка.ОборудованиеПредставление;
			
			ТабДок.Вывести(ОбластьСтрока);
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат ТабДок;
КонецФункции

&НаКлиенте
Процедура Стартовать(Команда)
	Старт(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КонтурАвтоматизацииПриИзменении(Элемент)
	Если Не РаботаСоСценариямиАвтоматизацииСервер.ПроверитьЗаполнениеПараметровКонтура(Объект.КонтурАвтоматизации) Тогда
		ПоказатьПредупреждение(, НСтр("ru='В контуре администрирования заполнены не все данные для запуска сценария. Необходимо заполнить'"));
		Объект.КонтурАвтоматизации = ПредопределенноеЗначение("Справочник.КонтурыАдминистрирования.ПустаяСсылка");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Сбросить(Команда)
	РаботаСоСценариямиАвтоматизацииСервер.ВернутьСценарийКНачальномуСостоянию(Объект.Ссылка, Ложь);

	ВосстановитьДеревоНаКлиенте(); 
	ОбновитьДеревоНаКлиенте();
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьДеревоНаКлиенте()
	ВосстановитьДеревоИзДанныхСценария();
	Прочитать();
КонецПроцедуры	

&НаКлиенте
Процедура СтартоватьТест(Команда)
	Старт(Истина);
КонецПроцедуры

&НаКлиенте
Процедура Старт(ЭтоТест)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	РаботаСоСценариямиАвтоматизацииСервер.СтартоватьСценарий(Объект.Ссылка, ЭтоТест);
	Прочитать();
	Если ЭтоТест И Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСценария.ТестСтартован") 
		Или Не ЭтоТест И Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСценария.Стартован") Тогда
		ФормуВРежимКонтроля(Истина);
	КонецЕсли;	
	ОбновитьДеревоНаКлиенте();
	УстановитьВидимостьДоступность();
КонецПроцедуры	

&НаКлиенте
Процедура ПрерватьСценарий(Команда)
	РаботаСоСценариямиАвтоматизацииСервер.ИзменитьСостояниеСценария(Объект.Ссылка, ПредопределенноеЗначение("Перечисление.СостоянияСценария.Прерван"),,Истина);
	Прочитать();
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	Прочитать();
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнение(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	РаботаСоСценариямиАвтоматизацииСервер.ПродолжитьВыполнениеПрерванногоСценария(Объект.Ссылка);
	Прочитать();
	ФормуВРежимКонтроля(Истина);
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыШаговАвтоматизацииПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.ПараметрыШаговАвтоматизации.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		Массив = Новый Массив;
		Массив.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Справка));
		Массив.Добавить(Новый ФорматированнаяСтрока(ТекДанные.Параметр + ": ", Новый Шрифт(,, Истина)));
		Массив.Добавить(Новый ФорматированнаяСтрока(?(ПустаяСтрока(ТекДанные.Описание), НСтр("ru='<без описания>'"), ТекДанные.Описание)));
		
		Элементы.ДекорацияОписание.Заголовок = Новый ФорматированнаяСтрока(Массив);
	Иначе
		Элементы.ДекорацияОписание.Заголовок = "";
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура РежимМонитора(Команда)
	ФормуВРежимКонтроля(Не Элементы.ФормаРежимМонитора.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыШаговАвтоматизацииПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Если ПараметрыПеретаскивания.Значение.Количество() > 0 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		ЗначениеШаблона = Неопределено;
		ПараметрыПеретаскивания.Значение[0].Свойство("ИмяШаблона", ЗначениеШаблона);
		Если ЗначениеШаблона <> Неопределено Тогда
			ТекДанные = Элементы.ПараметрыШаговАвтоматизации.ДанныеСтроки(Строка);
			Если ТекДанные <> Неопределено Тогда
				ТекДанные.Значение = ЗначениеШаблона;
				ПриИзмененииИсточникаЗначенияПараметра(ТекДанные);
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ГруппаДляЗаполненияПриИзмененииНаСервере(ГруппаДляЗаполнения) 
	ТаблицаДляЗаполнения = Объект.СопоставлениеШаблоновОборудования.Выгрузить();
	РаботаСоСценариямиАвтоматизацииМассовоеСоздание.ВыполнитьСопоставлениеОборудованияПоГруппировочнойЕдинице(ГруппаДляЗаполнения.СоставГруппы, ТаблицаДляЗаполнения);
	ЗначениеВДанныеФормы(ТаблицаДляЗаполнения, Объект.СопоставлениеШаблоновОборудования);
КонецПроцедуры

&НаКлиенте
Процедура ГруппаДляЗаполненияПриИзменении(Элемент)
	ГруппаДляЗаполненияПриИзмененииНаСервере(ГруппаДляБыстрогоЗаполнения);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыЗаполненияПараметровОбъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекДанные = Элементы.ОбъектыЗаполненияПараметров.ТекущиеДанные;
	Если ТекДанные <> Неопределено И ТекДанные.СпособЗаполнения = ПредопределенноеЗначение("Перечисление.СпособыЗаполненияПараметровКоманды.РучнойВвод") Тогда
		СтандартнаяОбработка = Ложь;
		
		Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатРедактированияВыражения", ЭтотОбъект);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("СписокШаблонов", Новый СписокЗначений);
		ПараметрыОткрытия.Вставить("ТекущееЗначение", Элемент.ТекстРедактирования);
		
		ДанныеВыбора = Элемент.ТекстРедактирования;
			
		Для Каждого Строка Из ОбъектыЗаполненияПараметров Цикл
			ПараметрыОткрытия.СписокШаблонов.Добавить(Строка.ИмяШаблона);
		КонецЦикла;	
		
		ОткрытьФорму("ОбщаяФорма.ФормированиеСоставногоПараметраСценария", ПараметрыОткрытия, Элемент,,,,Оповещение);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатРедактированияВыражения(ВозвращенныеПараметры, ДополнительныеПараметры) Экспорт
	Если ВозвращенныеПараметры <> Неопределено И ВозвращенныеПараметры.Свойство("РезультирующееВыражение") Тогда
		ТекДанные = Элементы.ОбъектыЗаполненияПараметров.ТекущиеДанные;
		Если ТекДанные <> Неопределено Тогда
			ТекДанные.Объект = ВозвращенныеПараметры.РезультирующееВыражение;
			ТекДанные.Значение = РаботаСоСценариямиАвтоматизацииКлиентСервер.ТрансляцияСоставногоПараметра(Строка(ТекДанные.Объект), ОбъектыЗаполненияПараметров);
			
			ПрописатьРеальноеЗначениеПараметраПоШаблону(ТекДанные.ИмяШаблона, ТекДанные.Значение);
			Модифицированность = Истина;
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура РежимПротоколированияПриИзменении(Элемент)
	ИзменитьФормуОтображенияСценария();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФормуОтображенияСценария()
	Если РежимПротоколирования Тогда
		Элементы.ГруппаОтображенияСценария.ТекущаяСтраница = Элементы.ПротоколВТабличномДокументе;
		ПолучитьПротокол();
	Иначе
		Элементы.ГруппаОтображенияСценария.ТекущаяСтраница = Элементы.Дерево;
		ОбновитьДеревоНаКлиенте();
	КонецЕсли;	
КонецПроцедуры	

#КонецОбласти