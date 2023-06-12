&НаКлиенте
Перем мДанныеФЗ;

&НаКлиенте
Перем СКОМПОНОВАТЬ_РЕЗУЛЬТАТ;

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СКОМПОНОВАТЬ_РЕЗУЛЬТАТ = "СкомпоноватьРезультатВФонеПроверка";
	
	Параметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТекущаяДата"));
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = ТекущаяДата();
		Параметр.Использование = Истина;
	КонецЕсли;
	
	СкомпоноватьРезультатВФоне();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	СкомпоноватьРезультатВФоне();
КонецПроцедуры

&НаКлиенте
Процедура СкомпоноватьРезультатВФоне()
	мДанныеФЗ = СкомпоноватьРезультатВФонеНаСервере(ЭтотОбъект.УникальныйИдентификатор, ЭтотОбъект.Результат, Отчет.РезультатДиаграмма);
	ПодключитьОбработчикОжидания(СКОМПОНОВАТЬ_РЕЗУЛЬТАТ, 1);
КонецПроцедуры

&НаКлиенте
Процедура СкомпоноватьРезультатВФонеПроверка()
	РезультатПроверки = СкомпоноватьРезультатВФонеПроверкаНаСервере(мДанныеФЗ);
	
	Если РезультатПроверки.Состояние <> "Активно" Тогда
		ОтключитьОбработчикОжидания(СКОМПОНОВАТЬ_РЕЗУЛЬТАТ);
		
		Если РезультатПроверки.Состояние = "Завершено" Тогда
			ЭтотОбъект.Результат = РезультатПроверки.Данные.ТабличныйДокумент;
			Отчет.РезультатДиаграмма = РезультатПроверки.Данные.РезультатДиаграмма;
			ЭтотОбъект.ДанныеРасшифровки = РезультатПроверки.Данные.ДанныеРасшифровкиАдрес;
		Иначе
			ВызватьИсключение(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СкомпоноватьРезультатВФонеПроверкаНаСервере(ДанныеФЗ)
	ФЗ = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ДанныеФЗ.УИДЗадания);
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("Состояние", "");
	РезультатПроверки.Вставить("Данные", Новый Структура);
	
	Если ФЗ.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		РезультатПроверки.Состояние = "Активно";
	ИначеЕсли ФЗ.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
		РезультатПроверки.Состояние = "Завершено";
		Результат = ПолучитьИзВременногоХранилища(ДанныеФЗ.АдресХранилища);
		
		РезультатПроверки.Данные.Вставить("ТабличныйДокумент",  Результат.Результат);
		РезультатПроверки.Данные.Вставить("РезультатДиаграмма",  Результат.РезультатДиаграмма);
		РезультатПроверки.Данные.Вставить("ДанныеРасшифровкиАдрес", ПоместитьВоВременноеХранилище(Результат.ДанныеРасшифровки, ДанныеФЗ.УИДФормы)); 
	Иначе
		РезультатПроверки.Состояние = "Ошибка";
	КонецЕсли;
	
	Возврат РезультатПроверки;
КонецФункции

&НаСервереБезКонтекста
Процедура ВывестиОжидание(ТабличныйДокумент)
	ТабличныйДокумент.Очистить();
	
	Картинка = БиблиотекаКартинок.ДлительнаяОперация48;
	Рисунок = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
	Рисунок.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии, 1);
	Индекс = ТабличныйДокумент.Рисунки.Индекс(Рисунок);
	ТабличныйДокумент.Рисунки[Индекс].Картинка = Картинка;
	Область = ТабличныйДокумент.Область(2,2,2,2);
	Область.ВысотаСтроки = 45;
	ТабличныйДокумент.Рисунки[Индекс].Расположить(Область);
	Область = ТабличныйДокумент.Область(1,1,1,1);
	Область.ШиринаКолонки = 1;
	Область.ВысотаСтроки = 5;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СкомпоноватьРезультатВФонеНаСервере(УникальныйИдентификаторФормы, пРезультат, пРезультатДиаграмма)
	
	ВывестиОжидание(пРезультат);
	ВывестиОжидание(пРезультатДиаграмма);
		
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификаторФормы);
	
	ПараметрыФоновогоЗадания = Новый Массив;
	ПараметрыФоновогоЗадания.Добавить("АнализЗадачНаРабочийСтол");
	ПараметрыФоновогоЗадания.Добавить(АдресХранилища);
	
	Задание = ФоновыеЗадания.Выполнить("ФункцииСКД.СкомпоноватьРезультатВФоне", ПараметрыФоновогоЗадания, УникальныйИдентификаторФормы, "Отчет ""Анализ задач на рабочий стол""");
	
	ДанныеФЗ = Новый Структура;
	ДанныеФЗ.Вставить("АдресХранилища", АдресХранилища);
	ДанныеФЗ.Вставить("УИДЗадания", Задание.УникальныйИдентификатор);
	ДанныеФЗ.Вставить("УИДФормы", УникальныйИдентификаторФормы);
	
	Возврат ДанныеФЗ;
	
КонецФункции



