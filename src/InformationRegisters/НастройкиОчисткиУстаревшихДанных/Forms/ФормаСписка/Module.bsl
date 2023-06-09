
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СоответствиеОбъектов.Загрузить(РегистрыСведений.НастройкиОчисткиУстаревшихДанных.СоответствиеОбъектов());
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Метаданные", СоответствиеОбъектов);
	ОткрытьФорму("РегистрСведений.НастройкиОчисткиУстаревшихДанных.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ПараметрыОткрытия = Новый Структура;
	СтрДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыОткрытия.Вставить("Ключ", КлючЗаписи(СтрДанные.ИмяОбъектаМетаданных, СтрДанные.ИзмерениеОтбора));
	ПараметрыОткрытия.Вставить("Метаданные", СоответствиеОбъектов);
	ОткрытьФорму("РегистрСведений.НастройкиОчисткиУстаревшихДанных.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура;
	СтрДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыОткрытия.Вставить("Ключ", КлючЗаписи(СтрДанные.ИмяОбъектаМетаданных, СтрДанные.ИзмерениеОтбора));
	ПараметрыОткрытия.Вставить("Метаданные", СоответствиеОбъектов);
	ОткрытьФорму("РегистрСведений.НастройкиОчисткиУстаревшихДанных.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма);
КонецПроцедуры

#КонецОбласти


#Область СлужбеныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция КлючЗаписи(ИмяОбъектаМетаданных, ИзмерениеОтбора)
	Возврат РегистрыСведений.НастройкиОчисткиУстаревшихДанных.СоздатьКлючЗаписи(Новый Структура("ИмяОбъектаМетаданных, ИзмерениеОтбора", ИмяОбъектаМетаданных, ИзмерениеОтбора));
КонецФункции

#КонецОбласти




