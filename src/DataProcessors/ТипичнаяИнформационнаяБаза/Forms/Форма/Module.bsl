
&НаКлиенте
Перем ПредыдущееЗначениеИБ;
&НаКлиенте
Перем РезультатЗапуска, ДатаНачалаФормирования;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВосстановитьНастройки();
	ПоИБ = ЗначениеЗаполнено(Объект.ИнформационнаяБаза);
	Для Каждого Страница Из Элементы.Страницы.ПодчиненныеЭлементы Цикл
		ОбновитьМетаДанныеСтраницы(ПоИБ, Страница.Имя);			
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	СохранитьНастройки(НастройкиКомпоновщиков, КоллекцияНастроек());
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	Если НЕ КонфиугарцияУказана() Тогда
		Возврат;
	КонецЕсли;	
	
	ПользовательскийПараметрПрофильКО = ЭлементПользовательскойНастройки(КомпоновщикПроизводительность, "ПрофильКлючевыхОпераций");
	Если ПользовательскийПараметрПрофильКО <> Неопределено И Не ЗначениеЗаполнено(ПользовательскийПараметрПрофильКО.Значение) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Не указан профиль ключевых операций на вкладке ""Производительность""";
		Сообщение.Поле = "КомпоновщикПроизводительность";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ОтменитьЗапущенныеФоновые(РезультатЗапуска);
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("ПоИБ", ПоИБ);
	ПараметрыФормирования.Вставить("Период", Период);
	ПараметрыФормирования.Вставить("Конфигурация", Объект.Конфигурация);
	ПараметрыФормирования.Вставить("ИнформационнаяБаза", Объект.ИнформационнаяБаза);
	ПараметрыФормирования.Вставить("УникальныйИдентификаторФормы", УникальныйИдентификатор);
	
	Компоновщики = Новый Структура;
	МассивСтраниц = Новый Массив;
	ДатаНачалаФормирования = ТекущаяДата();
	Для Каждого Страница Из Элементы.Страницы.ПодчиненныеЭлементы Цикл
		МассивСтраниц.Добавить(Страница.Имя);
		Компоновщики.Вставить("Компоновщик"+Страница.Имя, ЭтаФорма["Компоновщик"+Страница.Имя].ПользовательскиеНастройки);
		ЭтаФорма["Результат"+Страница.Имя] = Новый ТабличныйДокумент;
		ЭтаФорма["Результат"+Страница.Имя].Область("R3C1").Текст = "Начало формирования: " + ДатаНачалаФормирования;
	КонецЦикла;
	ПараметрыФормирования.Вставить("Компоновщики", Компоновщики);
	ПараметрыФормирования.Вставить("Страницы", МассивСтраниц);
	
	РезультатЗапуска = СформироватьНаСервере(ПараметрыФормирования);
	ПодключитьОбработчикОжидания("ПроверкаФормированияДанных", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТекущий(Команда)
	Если НЕ КонфиугарцияУказана() Тогда
		Возврат;
	КонецЕсли;
	
	ИмяСтраницы = Элементы.Страницы.ТекущаяСтраница.Имя;	
	
	Если ИмяСтраницы = "Производительность" Тогда
		ПользовательскийПараметрПрофильКО = ЭлементПользовательскойНастройки(КомпоновщикПроизводительность, "ПрофильКлючевыхОпераций");
		Если ПользовательскийПараметрПрофильКО <> Неопределено И Не ЗначениеЗаполнено(ПользовательскийПараметрПрофильКО.Значение) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Не указан профиль ключевых операций на вкладке ""Производительность""";
			Сообщение.Поле = "КомпоновщикПроизводительность";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОтменитьЗапущенныеФоновые(РезультатЗапуска, ИмяСтраницы);
	
	ДатаНачалаФормирования = ТекущаяДата();
	ЭтаФорма["Результат"+ИмяСтраницы] = Новый ТабличныйДокумент;
	ЭтаФорма["Результат"+ИмяСтраницы].Область("R3C1").Текст = "Начало формирования: " + ДатаНачалаФормирования;
	
	МассивСтраниц = Новый Массив;
	МассивСтраниц.Добавить(ИмяСтраницы);
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("ПоИБ", ПоИБ);
	ПараметрыФормирования.Вставить("Период", Период);
	ПараметрыФормирования.Вставить("Конфигурация", Объект.Конфигурация);
	ПараметрыФормирования.Вставить("ИнформационнаяБаза", Объект.ИнформационнаяБаза);
	ПараметрыФормирования.Вставить("УникальныйИдентификаторФормы", УникальныйИдентификатор);
	
	Компоновщики = Новый Структура;
	Компоновщики.Вставить("Компоновщик"+ИмяСтраницы, ЭтаФорма["Компоновщик"+ИмяСтраницы].ПользовательскиеНастройки);
	ПараметрыФормирования.Вставить("Компоновщики", Компоновщики);
	ПараметрыФормирования.Вставить("Страницы", МассивСтраниц);
	
	РезультатЗапуска = СформироватьНаСервере(ПараметрыФормирования);
	ПодключитьОбработчикОжидания("ПроверкаФормированияДанных", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПоУмолчанию(Команда)
	ИмяСтраницы = Элементы.Страницы.ТекущаяСтраница.Имя;
	НастройкиПоУмолчаниюНаСервере(ПоИБ, ИмяСтраницы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнформационнаяБазаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ПредыдущееЗначениеИБ = Объект.ИнформационнаяБаза;
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяБазаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ПредыдущееЗначениеИБ = Объект.ИнформационнаяБаза;
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяБазаОчистка(Элемент, СтандартнаяОбработка)
	ПредыдущееЗначениеИБ = Объект.ИнформационнаяБаза;
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяБазаПриИзменении(Элемент)
	ВариантПоИнформационнойБазе = НЕ Объект.ИнформационнаяБаза = ПредопределенноеЗначение("Справочник.ИнформационныеБазы.ПустаяСсылка");
	// Обновляем, только если изменился вариант формирования.
	Если ПоИБ <> ВариантПоИнформационнойБазе Тогда
		// Сохраним данные прошлого варианта.
		СохранитьНастройкиКомпоновщиков();
		ПоИБ = ВариантПоИнформационнойБазе;
		ОбновитьДанные(ПоИБ);	
	КонецЕсли;
	Если ПоИБ Тогда
		// Обновим конфигурацию.
		Объект.Конфигурация = КонфигурацияИБ(Объект.ИнформационнаяБаза);	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкиФормирования

&НаКлиенте
Процедура СохранитьНастройкиКомпоновщиков()
	Если ПредыдущееЗначениеИБ = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	Если ТипЗнч(НастройкиКомпоновщиков) <> Тип("Структура") Тогда
		НастройкиКомпоновщиков = Новый Структура("Реквизиты, КомпоновщикиОбщий, КомпоновщикиПоИнфоБазе", Новый Структура, Новый Структура, Новый Структура);
	КонецЕсли;                                                                                                                                              	
	Суффикс = ?(ЗначениеЗаполнено(ПредыдущееЗначениеИБ), "ПоИнфоБазе", "Общий");
	// Запомним настройки компоновщиков, соотвествующих текущему варианту (обший или по ИБ).
	Для Каждого Страница Из Элементы.Страницы.ПодчиненныеЭлементы Цикл
		НастройкиКомпоновщиков["Компоновщики"+Суффикс].Вставить("Компоновщик"+Страница.Имя, ЭтаФорма["Компоновщик"+Страница.Имя].ПользовательскиеНастройки);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция КоллекцияНастроек()
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Период", Период);
	КоллекцияНастроек.Вставить("Конфигурация", Объект.Конфигурация);
	КоллекцияНастроек.Вставить("ИнформационнаяБаза", Объект.ИнформационнаяБаза);
	Компоновщики = Новый Структура;
	Для Каждого Страница Из Элементы.Страницы.ПодчиненныеЭлементы Цикл
		Компоновщики.Вставить("Компоновщик"+Страница.Имя, ЭтаФорма["Компоновщик"+Страница.Имя].ПользовательскиеНастройки);
	КонецЦикла;
	КоллекцияНастроек.Вставить("Компоновщики", Компоновщики);
	Возврат КоллекцияНастроек;
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройки(Настройки, КоллекцияНастроек)
	
	КлючОбъекта = "Обработка.ТипичнаяИнформационнаяБаза.Форма";
	КлючНастроек = "НастройкиФормы";
	Пользователь = Строка(ПараметрыСеанса.ТекущийПользователь);
	
	Если ТипЗнч(Настройки) <> Тип("Структура") Тогда
		Настройки = Новый Структура("Реквизиты, КомпоновщикиОбщий, КомпоновщикиПоИнфоБазе", Новый Структура, Новый Структура, Новый Структура);
	КонецЕсли;
	Настройки.Реквизиты.Вставить("ИнформационнаяБаза", КоллекцияНастроек.ИнформационнаяБаза);
	Настройки.Реквизиты.Вставить("Конфигурация", КоллекцияНастроек.Конфигурация);
	Настройки.Реквизиты.Вставить("Период", КоллекцияНастроек.Период);
	Суффикс = ?(ЗначениеЗаполнено(КоллекцияНастроек.ИнформационнаяБаза), "ПоИнфоБазе", "Общий");
	// Запомним настройки компоновщиков, соотвествующих текущему варианту (обший или по ИБ).
	Для Каждого СтрЗапись Из КоллекцияНастроек.Компоновщики Цикл
		Настройки["Компоновщики"+Суффикс].Вставить(СтрЗапись.Ключ, СтрЗапись.Значение);
	КонецЦикла;
	
	ОписаниеНастроек = Новый ОписаниеНастроек;
	ОписаниеНастроек.Представление = "Настройки формы";
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек); 
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	КлючОбъекта = "Обработка.ТипичнаяИнформационнаяБаза.Форма";
	КлючНастроек = "НастройкиФормы";
	Пользователь = Строка(ПараметрыСеанса.ТекущийПользователь);
	
	НастройкиВыборка = ХранилищеОбщихНастроек.Выбрать(Новый Структура("КлючОбъекта, КлючНастроек, Пользователь", КлючОбъекта, КлючНастроек, Пользователь));
	Если НЕ НастройкиВыборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	КоллекцияНастроек = НастройкиВыборка.Настройки;
	НастройкиКомпоновщиков = Новый Структура("Реквизиты, КомпоновщикиОбщий, КомпоновщикиПоИнфоБазе", Новый Структура, Новый Структура, Новый Структура);
	// Запомним настройки компоновщиков, соотвествующих текущему варианту (обший или по ИБ).
	Для Каждого СтрЗапись Из КоллекцияНастроек.КомпоновщикиОбщий Цикл
		НастройкиКомпоновщиков.КомпоновщикиОбщий.Вставить(СтрЗапись.Ключ, СтрЗапись.Значение);
	КонецЦикла;
	Для Каждого СтрЗапись Из КоллекцияНастроек.КомпоновщикиПоИнфоБазе Цикл
		НастройкиКомпоновщиков.КомпоновщикиПоИнфоБазе.Вставить(СтрЗапись.Ключ, СтрЗапись.Значение);
	КонецЦикла;
	
	Период = КоллекцияНастроек.Реквизиты.Период;
	Объект.Конфигурация = КоллекцияНастроек.Реквизиты.Конфигурация;
	Объект.ИнформационнаяБаза = КоллекцияНастроек.Реквизиты.ИнформационнаяБаза;
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеОтчетов

// Входные параметры
// Структура ПараметрыФормирования, внутри:
// - Массив Страницы (строка)
// - ПоИБ
// - Период
// - Конфигурация
// - ИнформационнаяБаза
// - Компоновщики (содержит структуру с пользовательскими настройками.
//
&НаСервереБезКонтекста
Функция СформироватьНаСервере(ПараметрыФормирования)
	
	РезультатЗапуска = Новый Структура;	 
	
	Для Каждого Страница Из ПараметрыФормирования.Страницы Цикл
		
		ПараметрыФормированияОтчета = Новый Структура("ПоИБ, Период, Конфигурация, ИнформационнаяБаза");
		ЗаполнитьЗначенияСвойств(ПараметрыФормированияОтчета, ПараметрыФормирования);
		ПараметрыФормированияОтчета.Вставить("ПользовательскиеНастройки", ПараметрыФормирования.Компоновщики["Компоновщик" + Страница]);
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ПараметрыФормирования.УникальныйИдентификаторФормы);
		Ключ = "ФЗТипичнаяИнформационнаяБаза"+Страница;
		
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(Страница);
		МассивПараметров.Добавить(ПараметрыФормированияОтчета);
		МассивПараметров.Добавить(АдресХранилища);
		
		ПараметрыФоновогоЗадания = Новый Массив;
		ИмяЭкспортнойПроцедуры = "Обработки.ТипичнаяИнформационнаяБаза.СформироватьРезультатНаСервере";
		ПараметрыФоновогоЗадания.Добавить(ИмяЭкспортнойПроцедуры);
		ПараметрыФоновогоЗадания.Добавить(МассивПараметров);
			
		Задание = ФоновыеЗадания.Выполнить("Общий.ВыполнитьЗадание", ПараметрыФоновогоЗадания, , "ТипичнаяИнформационнаяБаза_"+Страница);
		
		ДанныеЗадания = Новый Структура;
		ДанныеЗадания.Вставить("АдресХранилища"+Страница, АдресХранилища);
		ДанныеЗадания.Вставить(Ключ, Задание.УникальныйИдентификатор);
		РезультатЗапуска.Вставить(Страница, ДанныеЗадания);		
		
	КонецЦикла;
	
	Возврат РезультатЗапуска;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверкаФормированияДанныхНаСервере(РезультатЗапуска)
	РезультатПроверки = Новый Структура;
	Для Каждого СтрЗапись Из РезультатЗапуска Цикл
		ФЗ = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(СтрЗапись.Значение["ФЗТипичнаяИнформационнаяБаза"+СтрЗапись.Ключ]);
		Если ФЗ.Состояние = СостояниеФоновогоЗадания.Активно Тогда
            РезультатПроверки.Вставить(СтрЗапись.Ключ, Неопределено);
		ИначеЕсли ФЗ.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
			РезультатПроверки.Вставить(СтрЗапись.Ключ, ПолучитьИзВременногоХранилища(СтрЗапись.Значение["АдресХранилища"+СтрЗапись.Ключ]));
        ИначеЕсли ФЗ.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
            РезультатПроверки.Вставить(СтрЗапись.Ключ, ПодробноеПредставлениеОшибки(ФЗ.ИнформацияОбОшибке));
        ИначеЕсли ФЗ.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
            РезультатПроверки.Вставить(СтрЗапись.Ключ, "Отменено");
        КонецЕсли;
	КонецЦикла;
	Возврат РезультатПроверки;
КонецФункции

&НаКлиенте
Процедура ПроверкаФормированияДанных()
    
    РезультатПроверки = ПроверкаФормированияДанныхНаСервере(РезультатЗапуска);
	
	Для Каждого СтрЗапись Из РезультатПроверки Цикл
		ЭтаФорма["Результат"+СтрЗапись.Ключ].Область("R4C1").Текст = "Длительность формирования: " + Формат(ТекущаяДата() - ДатаНачалаФормирования, "ЧН=0") + " сек";
		Если ТипЗнч(СтрЗапись.Значение) = Тип("ТабличныйДокумент") Тогда
			ЭтаФорма["Результат" + СтрЗапись.Ключ] = СтрЗапись.Значение;
		КонецЕсли;
		Если ТипЗнч(СтрЗапись.Значение) = Тип("Строка") Тогда
			Сообщить(СтрЗапись.Значение);
		КонецЕсли;
		Если СтрЗапись.Значение <> Неопределено Тогда
			РезультатЗапуска.Удалить(СтрЗапись.Ключ);
		КонецЕсли;
	КонецЦикла;   
        
    Если РезультатЗапуска.Количество() > 0 Тогда
        ПодключитьОбработчикОжидания("ПроверкаФормированияДанных", 1, Истина);
    КонецЕсли;
            
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьЗапущенныеФоновые(РезультатЗапуска, ИмяСтраницы = "")
	Если ТипЗнч(РезультатЗапуска) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	// Отменяем все, если имя страницы не указано.
	Если ПустаяСтрока(ИмяСтраницы) Тогда
		Для Каждого СтрЗапись Из РезультатЗапуска Цикл
			ФЗ = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(СтрЗапись.Значение["ФЗТипичнаяИнформационнаяБаза"+СтрЗапись.Ключ]);
			ФЗ.Отменить();
		КонецЦикла;
		РезультатЗапуска = Новый Структура;
	Иначе
		ДанныеЗадания = Неопределено;
		РезультатЗапуска.Свойство(ИмяСтраницы, ДанныеЗадания);
		Если ДанныеЗадания = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ФЗ = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ДанныеЗадания["ФЗТипичнаяИнформационнаяБаза"+ИмяСтраницы]);
		ФЗ.Отменить();
		РезультатЗапуска.Удалить(ИмяСтраницы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция КонфиугарцияУказана()
	Если Не ЗначениеЗаполнено(Объект.Конфигурация) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Не указана Конфигурация";
		Сообщение.Поле = "Объект.Конфигурация";
		Сообщение.Сообщить();
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаКлиенте
Функция ЭлементПользовательскойНастройки(Компоновщик, ИмяПараметра)
	Параметр = Компоновщик.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если Параметр <> Неопределено Тогда
		Возврат Компоновщик.ПользовательскиеНастройки.Элементы.Найти(Параметр.ИдентификаторПользовательскойНастройки);
	Иначе
		Возврат Неопределено;
	КонецЕсли;               
КонецФункции


&НаСервере
Процедура НастройкиСхемыПоУмолчанию(ИмяСхемы, ИмяКомпоновщика)
	СхемаКомпоновкиДанных = Обработки.ТипичнаяИнформационнаяБаза.ПолучитьМакет(ИмяСхемы);
	ХранилищеСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	КомпоновщикПоУмолчанию = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикПоУмолчанию.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ХранилищеСхемы));
	ЭтаФорма[ИмяКомпоновщика].Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ХранилищеСхемы));
	ЭтаФорма[ИмяКомпоновщика].ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	ЭтаФорма[ИмяКомпоновщика].ЗагрузитьПользовательскиеНастройки(КомпоновщикПоУмолчанию.ПользовательскиеНастройки);
КонецПроцедуры

// Обновляет данные страниц в соответствии с выбраным вариантом формирования.
// Варианты: Общий и по информационной базе.
//
&НаКлиенте
Процедура ОбновитьДанные(ПоИБ)
	Для Каждого Страница Из Элементы.Страницы.ПодчиненныеЭлементы Цикл
		Если Страница.Имя = "Производительность" Тогда
			ПрошлоеЗначение = Неопределено;
			ПользовательскийПараметрПрофильКО = ЭлементПользовательскойНастройки(КомпоновщикПроизводительность, "ПрофильКлючевыхОпераций");
			Если ПользовательскийПараметрПрофильКО <> Неопределено Тогда
				ПрошлоеЗначение = ПользовательскийПараметрПрофильКО.Значение;
			КонецЕсли;
		КонецЕсли;
		ОбновитьМетаДанныеСтраницы(ПоИБ, Страница.Имя);			
		Если Страница.Имя = "Производительность" И ЗначениеЗаполнено(ПрошлоеЗначение) Тогда
			ПользовательскийПараметрПрофильКО = ЭлементПользовательскойНастройки(КомпоновщикПроизводительность, "ПрофильКлючевыхОпераций");
			Если ПользовательскийПараметрПрофильКО <> Неопределено Тогда
				ПользовательскийПараметрПрофильКО.Значение = ПрошлоеЗначение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьМетаДанныеСтраницы(ПоИБ, ИмяСтраницы)
	Суффикс = ?(ПоИБ, "ПоИнфоБазе", "Общий");
	ИмяКомпоновщика = "Компоновщик" + ИмяСтраницы;
	НастройкиСхемыПоУмолчанию(ИмяСтраницы + Суффикс, ИмяКомпоновщика);
	
	// Загрузим данные текущего варианта, если они есть.
	Если ТипЗнч(НастройкиКомпоновщиков) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	Компоновщики = "Компоновщики"+Суффикс;
	Если Не НастройкиКомпоновщиков.Свойство(Компоновщики) Тогда
		Возврат;
	КонецЕсли;
	Если НастройкиКомпоновщиков[Компоновщики].Свойство(ИмяКомпоновщика) Тогда
		ЭтаФорма[ИмяКомпоновщика].ЗагрузитьПользовательскиеНастройки(НастройкиКомпоновщиков[Компоновщики][ИмяКомпоновщика]);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция КонфигурацияИБ(ИнформационнаяБаза)
	Запрос = Новый Запрос("ВЫБРАТЬ
	               |	ИнформацияСрезПоследних.Конфигурация КАК Конфигурация
	               |ИЗ
	               |	РегистрСведений.ИнформацияСрезПоследних КАК ИнформацияСрезПоследних
	               |ГДЕ
	               |	ИнформацияСрезПоследних.ИнформационнаяБаза = &ИнформационнаяБаза");
	Запрос.УстановитьПараметр("ИнформационнаяБаза", ИнформационнаяБаза);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Конфигурация;
	Иначе
		Возврат Справочники.Конфигурации.ПустаяСсылка();
	КонецЕсли;
КонецФункции

&НаСервере
Процедура НастройкиПоУмолчаниюНаСервере(ПоИБ, ИмяСтраницы)
	Суффикс = ?(ПоИБ, "ПоИнфоБазе", "Общий");
	ИмяКомпоновщика = "Компоновщик" + ИмяСтраницы;
	НастройкиСхемыПоУмолчанию(ИмяСтраницы + Суффикс, ИмяКомпоновщика);
КонецПроцедуры


#КонецОбласти

