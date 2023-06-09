////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ШагРаспределения = 0.5;
	ОбрезатьПоследние = 50;
	ИнформационнаяБаза = Параметры.ИнформационнаяБаза;
	Если ЗначениеЗаполнено(Параметры.ДатаОкончания) Тогда
		ДатаОкончания = Параметры.ДатаОкончания;
	Иначе
		ДатаОкончания = ТекущаяДата();
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ДатаНачала) Тогда
		ДатаНачала = Параметры.ДатаНачала;
	Иначе
		ДатаНачала = ДатаОкончания - 7*24*60*60;
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ИдентификаторОперации) Тогда
		Набор = РегистрыСведений.ОценкаПроизводительностиКлючевыеОперации.СоздатьНаборЗаписей();
		Набор.Отбор.УникальныйИдентификатор.Установить(Параметры.ИдентификаторОперации);
		Набор.Отбор.ИнформационнаяБаза.Установить(ИнформационнаяБаза);
		Набор.Прочитать();
		Если Набор.Количество() = 1 Тогда
			КлючеваяОперацияИдентификатор = Набор[0].УникальныйИдентификатор;
			КлючеваяОперация = Набор[0].Имя;
		КонецЕсли;
	КонецЕсли;
	Пользователь = Параметры.Пользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьЗаголовок();
	Если ЗначениеЗаполнено(ИнформационнаяБаза) И ЗначениеЗаполнено(КлючеваяОперацияИдентификатор)
		И ЗначениеЗаполнено(Пользователь) Тогда
		Сформировать(Неопределено);
	Иначе
		ОчиститьРезультаты();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ИдентификаторЗадания <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ИнформационнаяБазаПриИзменении(Элемент)
	ОчиститьРезультаты();
КонецПроцедуры

&НаКлиенте
Процедура ШагРаспределенияПриИзменении(Элемент)
	ОчиститьРезультаты();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ОчиститьРезультаты();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	ОчиститьРезультаты();
КонецПроцедуры

&НаКлиенте
Процедура КлючеваяОперацияПриИзменении(Элемент)
	ОчиститьРезультаты();
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	ОчиститьРезультаты();
	УстановитьЗаголовок();
КонецПроцедуры

&НаКлиенте
Процедура ОбрезатьПоследниеПриИзменении(Элемент)
	ОчиститьРезультаты();
КонецПроцедуры

&НаКлиенте
Процедура КлючеваяОперацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИнформационнаяБаза", ИнформационнаяБаза);
	ОписаниеОповещения = Новый ОписаниеОповещения("КлючеваяОперацияНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму("РегистрСведений.ОценкаПроизводительностиКлючевыеОперации.Форма.ФормаВыбора", ПараметрыФормы,,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура КлючеваяОперацияНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		КлючеваяОперацияИдентификатор = РезультатЗакрытия.УникальныйИдентификатор;
		КлючеваяОперация = РезультатЗакрытия.Имя;
		УстановитьЗаголовок();
		ОчиститьРезультаты();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлючеваяОперацияОчистка(Элемент, СтандартнаяОбработка)
	
	КлючеваяОперацияИдентификатор = Неопределено;
	КлючеваяОперация = Неопределено;
	ОчиститьРезультаты();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		РезультатВыполнения = ПрочитатьДанные();
		
		ПараметрыОбработчикаОжидания = Новый Структура;
		
		Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
			ОбщийКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "ФормированиеОтчета");
			Элементы.Результаты.ТекущаяСтраница = Элементы.ИндикаторДлительныхОпераций;
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		Иначе
			Элементы.Результаты.ТекущаяСтраница = Элементы.Результат;
		КонецЕсли;
	Исключение
		ОчиститьРезультаты();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Очищает данные отчета, останавливает фоновое задание
//
&НаКлиенте
Процедура ОчиститьРезультаты()

	ДиаграммаРаспределения.Очистить();
	Итоги.Очистить();
	ОбщийКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НЕАКТУАЛЬНОСТЬ");
	Элементы.Результаты.ТекущаяСтраница = Элементы.ИндикаторДлительныхОпераций;
	Если ИдентификаторЗадания <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовок()
	
	ТекстЗаголовка = НСтр("ru = '%КлючеваяОперация по %Пользователь'");
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%КлючеваяОперация", КлючеваяОперация);
	Заголовок = СтрЗаменить(ТекстЗаголовка, "%Пользователь", Пользователь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Формирование отчета в фоновом задании

// Запускает фоновое задание формирования отчета
//
&НаСервере
Функция ПрочитатьДанные()
	
	ПараметрыОтчета = ПараметрыОтчета();
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	Если Общий.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ОценкаПроизводительностиПоПользователям.ПрочитатьДанныеПоОперацииПоПользователю(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"ОценкаПроизводительностиПоПользователям.ПрочитатьДанныеПоОперацииПоПользователю", 
			ПараметрыОтчета);
						
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

// Помещает данные отчета в элементы формы
//
&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если РезультатВыполнения = Неопределено Тогда
		ДиаграммаРаспределения = Новый Диаграмма;
		Итоги.Очистить();
		Возврат;
	КонецЕсли;
	
	ДиаграммаРаспределения = РезультатВыполнения.Диаграмма;
	Статистика = РезультатВыполнения.Статистика;
	Итоги.Очистить();
	Строка = Итоги.Добавить();
	Строка.Показатель = НСтр("ru = 'Apdex'");
	Строка.Значение = Формат(Статистика.Apdex, "ЧДЦ=2; ЧН=0");
	Строка = Итоги.Добавить();
	Строка.Показатель = НСтр("ru = 'Среднее время выполнения операции (сек)'");
	Строка.Значение = Формат(Статистика.Среднее, "ЧДЦ=2; ЧН=0");
	Строка = Итоги.Добавить();
	Строка.Показатель = НСтр("ru = 'Наиболее частое время выполнения операции (сек)'");
	Строка.Значение = Статистика.ЧастоеВремя;
	Строка = Итоги.Добавить();
	Строка.Показатель = НСтр("ru = 'Максимальное время выполнения операции (сек)'");
	Строка.Значение = НСтр("ru = '%Длительность (замер выполнен %Время)'");
	Строка.Значение = СтрЗаменить(Строка.Значение, "%Длительность", Формат(Статистика.Максимум, "ЧДЦ=2; ЧН=0"));
	Строка.Значение = СтрЗаменить(Строка.Значение, "%Время", Формат(Статистика.ДатаМаксимума, "ДФ='H:mm:ss dd.MM.yy'"));
	Строка = Итоги.Добавить();
	Строка.Показатель = НСтр("ru = 'Минимальное время выполнения операции (сек)'");
	Строка.Значение = НСтр("ru = '%Длительность (замер выполнен %Время)'");
	Строка.Значение = СтрЗаменить(Строка.Значение, "%Длительность", Формат(Статистика.Минимум, "ЧДЦ=2; ЧН=0"));
	Строка.Значение = СтрЗаменить(Строка.Значение, "%Время", Формат(Статистика.ДатаМинимума, "ДФ='H:mm:ss dd.MM.yy'"));
	Строка = Итоги.Добавить();
	Строка.Показатель = НСтр("ru = 'Дисперсия'");
	Строка.Значение = Формат(Статистика.Дисперсия, "ЧДЦ=2; ЧН=0");
	Строка = Итоги.Добавить();
	Строка.Показатель = НСтр("ru = 'Посчитано по числу замеров'");
	Строка.Значение = Формат(Статистика.ОбщееЧислоЗамеров, "ЧН=0");

	ИдентификаторЗадания = Неопределено;
	
КонецПроцедуры

// Помещает данные формы в структуру для передачи в отчет
//
&НаСервере
Функция ПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ИнформационнаяБаза", ИнформационнаяБаза);
	ПараметрыОтчета.Вставить("Пользователь", Пользователь);
	ПараметрыОтчета.Вставить("ДатаНачала", ДатаНачала);
	ПараметрыОтчета.Вставить("ДатаОкончания", ДатаОкончания);
	ПараметрыОтчета.Вставить("КлючеваяОперацияИдентификатор", КлючеваяОперацияИдентификатор);
	ПараметрыОтчета.Вставить("КлючеваяОперация", КлючеваяОперация);
	ПараметрыОтчета.Вставить("ШагРаспределения", ШагРаспределения);
	ПараметрыОтчета.Вставить("ОбрезатьПоследние", ОбрезатьПоследние / 100);

	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()  
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			Элементы.Результаты.ТекущаяСтраница = Элементы.Результат;
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОчиститьРезультаты();
		ВызватьИсключение;
	КонецПопытки;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбрезатьПоследние > 100 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Значение процента должно быть не более 100'");
		Сообщение.Поле = "ОбрезатьПоследние";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры
